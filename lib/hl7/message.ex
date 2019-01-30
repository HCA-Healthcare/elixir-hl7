defmodule HL7.Message do
  require Logger

  @segment_terminator "\r"

  @type t :: %HL7.Message{
               raw: nil | binary(),
               segments: nil | list(),
               header: nil | HL7.Header.t()
        }

  @type raw_hl7 :: String.t() | HL7.RawMessage.t()
  @type parsed_hl7 :: [list()] | HL7.Message.t()
  @type content_hl7 :: raw_hl7() | parsed_hl7()

  defstruct raw: nil,
            segments: nil,
            header: nil

  @doc """
  Creates an `HL7.Message` struct. It will
  extract basic header information (e.g. encoding characters, message type)
  and hold the raw HL7 for further processing.

  If constructed with lists of segment data, it will generate the raw content
  as well the parsed list data.

  Invalid MSH information will return an `HL7.InvalidMessage` struct.
  """

  @spec raw(content_hl7()) :: HL7.RawMessage.t() | HL7.InvalidMessage.t()
  def raw(
        <<"MSH", field_separator::binary-size(1), encoding_characters::binary-size(4),
          field_separator::binary-size(1), _::binary()>> = raw_text
      ) do
    separators = HL7.Separators.new(field_separator, encoding_characters)
    header = HL7.Message.extract_header(raw_text, separators)

    %HL7.RawMessage{raw: raw_text, header: header}
  end

  def raw(segments) when is_list(segments) do
    [msh | other_segments] = segments
    [name, field_separator | msh_tail] = msh
    [encoding_characters | _] = msh_tail
    msh_without_field_separator = [name | msh_tail]

    [component, repeat, _escape_char, subcomponent] = String.graphemes(encoding_characters)

    join_by_character_list = [field_separator, repeat, component, subcomponent]

    raw_text =
      join_with_separators(
        [msh_without_field_separator | other_segments],
        [@segment_terminator | join_by_character_list]
      ) <> @segment_terminator

    HL7.Message.raw(raw_text)
  end

  def raw(raw_text) when is_binary(raw_text) do
      %HL7.InvalidMessage{
        raw: raw_text,
        created_at: DateTime.utc_now()
      }
  end

  def raw(%HL7.Message{segments: segments}) do
    HL7.Message.raw(segments)
  end

  def raw(%HL7.RawMessage{} = raw_msg) do
    raw_msg
  end

  def extract_header(raw_text, %HL7.Separators{} = separators) when is_binary(raw_text) do
    msh = raw_text |> get_raw_msh_segment() |> split_segment_text(separators)

    destructure(
      [
        _,
        _,
        _,
        sending_application,
        sending_facility,
        _,
        _,
        message_date_time,
        _,
        message_type_and_trigger_event,
        _,
        _,
        hl7_version
      ],
      msh
    )

    message_type = message_type_and_trigger_event |> get_value(0, 0)
    trigger_event = message_type_and_trigger_event |> get_value(0, 1)

    %HL7.Header{
      separators: separators,
      sending_application: sending_application |> get_value(),
      sending_facility: sending_facility |> get_value(),
      message_date_time: message_date_time |> get_value(),
      message_type: message_type,
      trigger_event: trigger_event,
      hl7_version: hl7_version |> get_value()
    }
  end

  @doc """
  Creates an `HL7.Message` struct with parsed segment list data. It will
  extract basic header information (e.g. encoding characters, message type)
  and hold the raw HL7 for further processing.

  If constructed with lists of segment data, it will generate the raw content
  as well the parsed list data.

  Invalid MSH information will return an `HL7.InvalidMessage`.
  """
  @spec new(content_hl7()) :: HL7.Message.t() | HL7.InvalidMessage.t()
  def new(%HL7.RawMessage{raw: raw_text, header: header}) do
    segments =
      raw_text
      |> String.split(@segment_terminator, trim: true)
      |> Enum.map(&split_segment_text(&1, header.separators))

    %HL7.Message{raw: raw_text, segments: segments, header: header}
  end

  def new(%HL7.Message{} = msg) do
    msg
  end

  def new(raw_text) when is_binary(raw_text) do
    raw_text
    |> HL7.Message.raw()
    |> HL7.Message.new()
  end

  def new(segments) when is_list(segments) do
    segments
    |> HL7.Message.raw()
    |> HL7.Message.new()
  end


  @doc """
  Returns a parsed list of segments from an HL7 message or content.
  """
  @spec get_segments(parsed_hl7()) :: [list()]
  def get_segments(msg) when is_list(msg) do
    msg
  end

  def get_segments(%HL7.Message{segments: segments}) do
    segments
  end

  @doc """
  Returns the first parsed segment matching `segment_name` from an HL7 message or content.
  """

  @spec get_segment(parsed_hl7(), String.t()) :: list()
  def get_segment(%HL7.Message{} = msg, segment_name) when is_binary(segment_name) do
    msg |> get_segments() |> get_segment(segment_name)
  end

#  @spec get_segment(segment_list :: [list()], segment_name :: String.t()) :: list()
  def get_segment(segments, segment_name)
      when is_list(segments) and is_binary(segment_name) do
    segments
    |> Enum.find(fn segment ->
      [h | _] = segment
      h == segment_name
    end)
  end

  @doc """
  Returns a list of parts extracted from an HL7 message or content. If the indices begin
  with a segment name, only data from matching segment types will be included. Numeric
  indices are 0-based (unlike `HL7.Query` which uses 1-based indices as in HL7 itself).
  """

  @spec get_segment_parts(parsed_hl7(), segment_name :: String.t()) :: list()

  def get_segment_parts(%HL7.Message{} = msg, indices) when is_list(indices) do
    msg
    |> get_segments()
    |> get_segment_parts(indices)
  end

  def get_segment_parts(segments, [<<segment_name::binary-size(3)>> | indices])
      when is_list(segments) do
    segments
    |> Enum.filter(fn [name | _tail] -> name == segment_name end)
    |> Enum.map(fn segment -> get_part(segment, indices) end)
  end

  def get_segment_parts(segments, indices) when is_list(segments) and is_list(indices) do
    segments
    |> Enum.map(fn segment -> get_part(segment, indices) end)
  end

  @doc """
  Returns a part from the first segment extracted from an HL7 message or content. If the indices begin
  with a segment name, only data from matching segment types will be included. Numeric
  indices are 0-based (unlike `HL7.Query` which uses 1-based indices as in HL7 itself).
  """

  @spec get_segment_part(parsed_hl7(), list()) :: list() | String.t() | nil

  def get_segment_part(%HL7.Message{} = msg, indices) when is_list(indices) do
    msg
    |> get_segments()
    |> get_segment_part(indices)
  end

  def get_segment_part(segments, [<<segment_name::binary-size(3)>> | indices])
      when is_list(segments) do
    segments
    |> Stream.filter(fn [name | _tail] -> name == segment_name end)
    |> Stream.map(fn segment -> get_part(segment, indices) end)
    |> Enum.at(0)
  end

  def get_segment_part(segments, indices) when is_list(segments) and is_list(indices) do
    segments
    |> Stream.take(1)
    |> Stream.map(fn segment -> get_part(segment, indices) end)
    |> Enum.at(0)
  end

  @doc false
  # used by HL7.Query

  def update_segments(segments, [<<segment_name::binary-size(3)>> | indices], transform) do
    segments
    |> Enum.map(fn
      [^segment_name | _] = segment -> update_part(segment, indices, transform)
      segment -> segment
    end)
  end

  def update_segments(segments, indices, transform) do
    segments
    |> Enum.map(fn segment -> update_part(segment, indices, transform) end)
  end

  # def trim_part (remove end part of segments)

  @doc false
  # used by HL7.Query

  def update_part(data, [], transform) when is_function(transform) do
    transform.(data)
  end

  def update_part(_data, [], transform) when is_list(transform) or is_binary(transform) do
    transform
  end

  def update_part(data, [segment_name | remaining_indices], transform)
      when is_list(data) and is_binary(segment_name) do
    i = get_segment_index(data, segment_name)
    List.update_at(data, i, fn d -> update_part(d, remaining_indices, transform) end)
  end

  def update_part(data, [i | remaining_indices], transform)
      when is_binary(data) and is_integer(i) do
    [data | empty_string_list(i)]
    |> List.update_at(0, fn d -> update_part(d, remaining_indices, transform) end)
    |> Enum.reverse()
  end

  def update_part(data, [i | remaining_indices], transform)
      when is_list(data) and is_integer(i) do
    count = Enum.count(data)

    case i < count do
      true ->
        List.update_at(data, i, fn d -> update_part(d, remaining_indices, transform) end)

      false ->
        data
        |> Enum.reverse()
        |> empty_string_list(i - count + 1)
        |> List.update_at(0, fn d -> update_part(d, remaining_indices, transform) end)
        |> Enum.reverse()
    end
  end

  @spec get_part(parsed_hl7, list()) :: nil | list() | binary()
  def get_part(%HL7.Message{} = msg, [segment | indices])
      when is_list(indices) and is_binary(segment) do
    msg
    |> get_segment(segment)
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
        get_segment(data, i) |> get_part(remaining_indices)

      _ when is_integer(i) and is_list(data) ->
        Enum.at(data, i) |> get_part(remaining_indices)
    end
  end

  @spec get_part(
          hl7_msg :: String.t() | [list()] | HL7.Message.t(),
          i1 :: binary() | non_neg_integer(),
          i2 :: non_neg_integer(),
          i3 :: non_neg_integer(),
          i4 :: non_neg_integer(),
          i5 :: non_neg_integer()
        ) :: nil | list() | binary()
  def get_part(data, i1 \\ nil, i2 \\ nil, i3 \\ nil, i4 \\ nil, i5 \\ nil) do
    get_part(data, [i1, i2, i3, i4, i5])
  end

  @spec get_value(
          parsed_hl7(),
          i1 :: binary() | non_neg_integer(),
          i2 :: non_neg_integer(),
          i3 :: non_neg_integer(),
          i4 :: non_neg_integer(),
          i5 :: non_neg_integer()
        ) :: nil | list() | binary()
  def get_value(data, i1 \\ 0, i2 \\ 0, i3 \\ 0, i4 \\ 0, i5 \\ 0) do
    get_part(data, [i1, i2, i3, i4, i5])
  end

  # -----------------
  # Private functions
  # -----------------

  defp get_raw_msh_segment(<<"MSH", _::binary()>> = raw_text) do
    raw_text
    |> String.splitter(@segment_terminator)
    |> Enum.at(0)
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
    |> Enum.map(&unwrap_length_one_lists(&1))
  end

  defp split_with_separators(text, []) do
    text
  end

  defp unwrap_length_one_lists(v) do
    case v do
      [text] when is_binary(text) -> text
      _ -> v
    end
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

  defp empty_string_list(n) do
    empty_string_list([], n)
  end

  defp empty_string_list(list, 0) do
    list
  end

  defp empty_string_list(list, n) do
    empty_string_list(["" | list], n - 1)
  end

  @spec get_segment_index(parsed_hl7(), segment_name :: String.t()) :: integer()
  defp get_segment_index(segments, segment_name)
       when is_list(segments) and is_binary(segment_name) do
    segments
    |> Enum.find_index(fn segment ->
      [h | _] = segment
      h == segment_name
    end)
  end

  #  defp get_segment_from_raw_message(raw_message, segment_name) do
  #    raw_message
  #    |> String.splitter(@segment_terminator)
  #    |> Stream.filter(fn segment_text -> String.length(segment_text) > 3 end)
  #    |> Stream.filter(fn <<message_type::binary-size(3), _::binary>> ->
  #      segment_name == message_type
  #    end)
  #    |> Enum.at(0)
  #  end

  defimpl String.Chars, for: HL7.Message do
    require Logger

    def to_string(%HL7.Message{raw: raw_text}) do
      raw_text
    end
  end
end
