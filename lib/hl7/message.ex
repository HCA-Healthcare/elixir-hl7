defmodule HL7.InvalidMessage do
  defstruct id: "",
            message_type: "",
            segments: [],
            facility: "",
            message_date_time: nil,
            separators: nil,
            problems: []
end

defmodule HL7.Message do
  require Logger

  @segment_terminator "\r"

  defstruct id: "",
            message_type: "",
            id_type: nil,
            content: nil,
            status: :empty,
            facility: "",
            message_date_time: nil,
            separators: nil,
            hl7_version: nil

  @doc """
  Creates a Message struct from a raw HL7 string. The Message will
  extract basic header information (e.g. encoding characters, message type)
  and hold the raw HL7 for further processing.
  """

  @spec new(raw_msg :: String.t()) :: %HL7.Message{status: :raw}
  def new(<<"MSH", _::binary()>> = raw_message) do
    separators = HL7.Separators.new(raw_message)

    hl7_message = %HL7.Message{
      content: raw_message,
      separators: separators,
      status: :raw
    }

    msh = raw_message |> get_raw_msh_segment() |> split_segment_text(separators)

    destructure(
      [
        _,
        _,
        _,
        _,
        facility,
        _,
        _,
        message_date_time,
        _,
        message_code_and_trigger,
        _,
        _,
        hl7_version
      ],
      msh
    )

    message_code = message_code_and_trigger |> get_value(0, 0)
    trigger_event = message_code_and_trigger |> get_value(0, 1)

    %HL7.Message{
      hl7_message
      | facility: facility |> get_value(),
        message_date_time: message_date_time |> get_value(),
        message_type: message_code <> " " <> trigger_event,
        hl7_version: hl7_version |> get_value()
    }
  end

  @spec get_content(hl7_msg :: %HL7.Message{status: :raw}) :: {:raw, String.t()}
  @spec get_content(hl7_msg :: %HL7.Message{status: :lists}) :: {:lists, list(list)}
  @spec get_content(hl7_msg :: %HL7.Message{status: :structs}) :: {:structs, list(struct)}

  def get_content(%HL7.Message{} = hl7_message) do
    {hl7_message.status, hl7_message.content}
  end

  @spec get_content(hl7_msg :: %HL7.Message{}, content_type :: :raw) :: String.t()
  @spec get_content(hl7_msg :: %HL7.Message{}, content_type :: :lists) :: list(list)
  @spec get_content(hl7_msg :: %HL7.Message{}, content_type :: :structs) :: list(struct)

  def get_content(%HL7.Message{} = hl7_message, content_type) when is_atom(content_type) do
    case content_type do
      :raw -> hl7_message |> get_raw
      :lists -> hl7_message |> get_lists
      :structs -> hl7_message |> get_structs
    end
  end

  @spec get_raw(hl7_msg :: %HL7.Message{}) :: String.t()
  @spec get_raw(raw_msg :: String.t()) :: String.t()

  def get_raw(%HL7.Message{status: :raw} = hl7_message) do
    hl7_message.content
  end

  def get_raw(%HL7.Message{} = hl7_message) do
    hl7_message |> make_raw() |> get_raw()
  end

  @spec get_lists(hl7_msg :: %HL7.Message{}) :: list(list)
  @spec get_lists(raw_msg :: String.t()) :: list(list)

  def get_lists(%HL7.Message{status: :lists} = hl7_message) do
    hl7_message.content
  end

  def get_lists(%HL7.Message{} = hl7_message) do
    hl7_message |> make_lists() |> get_lists()
  end

  def get_lists(raw_message) when is_binary(raw_message) do
    raw_message |> make_lists() |> get_lists()
  end

  @spec get_structs(hl7_msg :: %HL7.Message{}) :: list(struct)
  @spec get_structs(raw_msg :: String.t()) :: list(struct)

  def get_structs(%HL7.Message{status: :structs} = hl7_message) do
    hl7_message.content
  end

  def get_structs(%HL7.Message{} = hl7_message) do
    hl7_message |> make_structs() |> get_structs()
  end

  def get_structs(raw_message) when is_binary(raw_message) do
    raw_message |> make_structs() |> get_structs()
  end

  @doc """
  Converts message content to raw text.
  """

  @spec make_raw(hl7_msg :: %HL7.Message{}) :: %HL7.Message{status: :raw, content: String.t()}
  def make_raw(%HL7.Message{status: :raw} = hl7_message) do
    hl7_message
  end

  def make_raw(%HL7.Message{content: lists, status: :lists} = hl7_message) do
    [msh | other_segments] = lists
    [name, _field_separator | msh_tail] = msh
    msh_without_field_separator = [name | msh_tail]

    raw =
      join_with_separators(
        [msh_without_field_separator | other_segments],
        [@segment_terminator | hl7_message.separators.delimiter_list])

    %HL7.Message{hl7_message | content: raw <> @segment_terminator, status: :raw}
  end

  def make_raw(%HL7.Message{status: :structs} = hl7_message) do
    hl7_message
    |> make_lists
    |> make_raw
  end

  def make_lists(%HL7.Message{content: raw_message, status: :raw} = hl7_message) do
    lists =
      raw_message
      |> String.split(@segment_terminator, trim: true)
      |> Enum.map(&split_segment_text(&1, hl7_message.separators))

    %HL7.Message{hl7_message | content: lists, status: :lists}
  end

  def make_lists(%HL7.Message{status: :lists} = hl7_message) do
    hl7_message
  end

  def make_lists(%HL7.Message{content: structs, status: :structs} = hl7_message) do
    lists =
      structs
      |> Enum.map(fn s -> apply(s.__struct__, :to_list, [s]) end)

    %HL7.Message{hl7_message | content: lists, status: :lists}
  end

  def make_lists(raw_message) when is_binary(raw_message) do
    raw_message
    |> HL7.Message.new()
    |> HL7.Message.make_lists()
  end

  def make_structs(%HL7.Message{status: :raw} = hl7_message) do
    hl7_message |> make_lists |> make_structs
  end

  def make_structs(%HL7.Message{content: lists, status: :lists} = hl7_message) do
    mod = get_segments_module(hl7_message.hl7_version)

    structs =
      lists
      |> Enum.map(fn seg -> apply(mod, :parse, [seg]) end)

    %HL7.Message{hl7_message | content: structs, status: :structs}
  end

  def make_structs(%HL7.Message{status: :structs} = hl7_message) do
    hl7_message
  end

  def make_structs(raw_message) when is_binary(raw_message) do
    raw_message
    |> HL7.Message.new()
    |> HL7.Message.make_structs()
  end

  def get_segment(%HL7.Message{status: :raw, content: content}, segment_name) do
    get_segment_from_raw_message(content, segment_name)
  end

  def get_segment(%HL7.Message{status: :lists, content: content}, segment_name)
      when is_binary(segment_name) do
    content
    |> Enum.find(fn seg ->
      [s | _] = seg
      s == segment_name
    end)
  end

  def get_segment(%HL7.Message{status: :structs, content: content}, segment_name)
      when is_binary(segment_name) do
    content
    |> Enum.find(fn seg ->
      seg.segment == segment_name
    end)
  end

  def get_segment(raw_message, segment_name)
      when is_binary(raw_message) and is_binary(segment_name) do
    get_segment_from_raw_message(raw_message, segment_name)
  end

  def get_segment(nested_lists, segment_name)
      when is_list(nested_lists) and is_binary(segment_name) do
    nested_lists
    |> Enum.find(fn seg -> get_value(seg) == segment_name end)
  end

  def get_segments(%HL7.Message{status: :raw, content: content}, segment_name) do
    get_segments_from_raw_message(content, segment_name)
  end

  def get_segments(%HL7.Message{status: :lists, content: content}, segment_name)
      when is_binary(segment_name) do
    content
    |> Enum.filter(fn seg ->
      [[s] | _] = seg
      s == segment_name
    end)
  end

  def get_segments(%HL7.Message{status: :structs, content: content}, segment_name)
      when is_binary(segment_name) do
    content
    |> Enum.filter(fn seg ->
      [s] = seg.segment
      s == segment_name
    end)
  end

  def get_segments(raw_message, segment_name)
      when is_binary(raw_message) and is_binary(segment_name) do
    get_segments_from_raw_message(raw_message, segment_name)
  end

  def get_segments(nested_lists, segment_name)
      when is_list(nested_lists) and is_binary(segment_name) do
    nested_lists
    |> Enum.filter(fn seg -> get_value(seg) == segment_name end)
  end

  def get_part(%HL7.Message{status: :raw} = hl7_message, indices) when is_list(indices) do
    Logger.warn(
      "Calling HL7.Message.get_part/2 on a :raw message is not performant. Consider calling make_lists/1 if used repeatedly."
    )

    hl7_message
    |> get_lists
    |> get_part(indices)
  end

  def get_part(%HL7.Message{status: :lists} = hl7_message, [segment | indices])
      when is_list(indices) and is_binary(segment) do
    hl7_message
    |> get_segment(segment)
    |> get_part(indices)
  end

  def get_part(%HL7.Message{status: :lists, content: content}, indices) when is_list(indices) do
    content
    |> get_part(indices)
  end

  def get_part(%HL7.Message{status: :structs} = hl7_message, [segment | indices])
      when is_list(indices) and is_binary(segment) do
    hl7_message
    |> get_segment(segment)
    |> get_part(indices)
  end

  def get_part(%HL7.Message{status: :structs, content: content}, indices) when is_list(indices) do
    content
    |> get_part(indices)
  end

  def get_part(data, []) do
    data
  end

  def get_part(data, [i | remaining_indices]) do
    case data do
      nil ->
        data

      _ when is_nil(i) ->
        data

      _ when is_binary(data) ->
        data

      _ when is_binary(i) and is_list(data) ->
        Enum.find(data, fn d -> get_value(d) == i end) |> get_part(remaining_indices)

      _ when is_integer(i) and is_list(data) ->
        Enum.at(data, i) |> get_part(remaining_indices)

      _ when is_map(data) ->
        apply(data.__struct__, :get_part, [data, i]) |> get_part(remaining_indices)
    end
  end

  def get_part(data, i1 \\ nil, i2 \\ nil, i3 \\ nil, i4 \\ nil, i5 \\ nil) do
    get_part(data, [i1, i2, i3, i4, i5])
  end

  def get_value(data, i1 \\ 0, i2 \\ 0, i3 \\ 0, i4 \\ 0, i5 \\ 0) do
    get_part(data, [i1, i2, i3, i4, i5])
  end

  # -----------------
  # Private functions
  # -----------------

  defp get_raw_msh_segment(<<"MSH", _::binary()>> = raw_message) do
    raw_message
    |> String.splitter(@segment_terminator)
    |> Enum.at(0)
  end

  defp get_segments_module(hl7_version) do
    hl7_version
    |> to_string()
    |> String.replace(".", "_")
    |> (fn number_part -> "Elixir.HL7.V" <> number_part <> ".Segments" end).()
    |> String.to_existing_atom()
  end

  defp split_segment_text(<<"MSH", _rest::binary()>> = raw_text, separators) do
    raw_text
    |> strip_msh_encoding
    |> split_into_fields(separators)
    |> add_msh_encoding_fields(separators)
  end

  defp split_segment_text(raw_text, separators) do
    raw_text |> split_into_fields(separators)
  end

  defp split_into_fields(text, separators) do
    text
    |> String.split(separators.field)
    |> Enum.map(&split_with_text_delimiters(&1, separators))
  end

  defp split_with_text_delimiters("", _separators) do
    ""
  end

  defp split_with_text_delimiters(text, separators) do
    delimiters = get_delimiters_in_text(text, separators)
    text |> split_with_separators(delimiters)
  end

  defp get_delimiters_in_text(text, separators) do
    find_delimiters(text, separators.delimiter_check)
  end

  defp find_delimiters(_text, []) do
    []
  end

  defp find_delimiters(text, [split_character | remaining] = delimiters) do
    case text |> String.contains?(split_character) do
      true -> Enum.reverse(delimiters)
      false -> find_delimiters(text, remaining)
    end
  end

  defp split_with_separators("", _) do
    ""
  end

  defp split_with_separators(text, [split_character | remaining_characters]) do
    text
    |> String.split(split_character)
    |> Enum.map(&split_with_separators(&1, remaining_characters))
  end

  defp split_with_separators(text, []) do
    text
  end

  defp join_with_separators(text, _separators) when is_binary(text) do
    text
  end

  defp join_with_separators(lists, [split_character | remaining_characters]) do
    lists
    |> Enum.map(&join_with_separators(&1, remaining_characters))
    |> Enum.join(split_character)
  end

  defp strip_msh_encoding(<<"MSH", _encoding_chars::binary-size(5), msh_rest::binary>>) do
    "MSH" <> msh_rest
  end

  defp add_msh_encoding_fields([msh_name | msh_tail], separators) do
    [msh_name, separators.field, separators.encoding_characters | msh_tail]
  end

  defp get_segment_from_raw_message(raw_message, segment_name) do
    raw_message
    |> String.splitter(@segment_terminator)
    |> Stream.filter(fn segment_text -> String.length(segment_text) > 3 end)
    |> Stream.filter(fn <<message_type::binary-size(3), _::binary>> ->
      segment_name == message_type
    end)
    |> Enum.at(0)
  end

  defp get_segments_from_raw_message(raw_message, segment_name) do
    raw_message
    |> String.split(@segment_terminator)
    |> Enum.filter(fn segment_text -> String.length(segment_text) > 3 end)
    |> Enum.filter(fn <<message_type::binary-size(3), _::binary>> ->
      segment_name == message_type
    end)
  end

  defimpl String.Chars, for: HL7.Message do
    require Logger

    def to_string(%HL7.Message{} = hl7_message) do
      hl7_message |> HL7.Message.get_content(:raw)
    end
  end
end
