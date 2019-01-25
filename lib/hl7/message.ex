defmodule HL7.Message do
  require Logger

  @segment_terminator "\r"

  @type t :: %HL7.Message{
          id: nil | binary(),
          created_at: any(),
          raw: nil | binary(),
          lists: nil | list(),
          message_type: nil | binary(),
          trigger_event: nil | binary(),
          facility: nil | binary(),
          application: nil | binary(),
          message_date_time: any(),
          separators: HL7.Separators.t(),
          hl7_version: nil | binary()
        }

  @type raw_hl7 :: String.t()
  @type parsed_hl7 :: [list()]
  @type message_content :: raw_hl7() | parsed_hl7()
  @type message_struct :: HL7.Message.t() | HL7.InvalidMessage.t()
  @type content_or_valid_hl7 :: message_content() | HL7.Message.t()

  defstruct id: nil,
            created_at: nil,
            raw: nil,
            lists: nil,
            message_type: nil,
            trigger_event: nil,
            facility: nil,
            application: nil,
            message_date_time: nil,
            separators: nil,
            hl7_version: nil

  @doc """
  Creates an `HL7.Message` struct. It will
  extract basic header information (e.g. encoding characters, message type)
  and hold the raw HL7 for further processing.

  If constructed with lists of segment data, it will generate the raw content
  as well the parsed list data.

  Invalid MSH information will return an `HL7.InvalidMessage` struct.
  """

  @spec new(message_content()) :: message_struct()
  def new(<<"MSH", _::binary()>> = raw_message) do
    separators = HL7.Separators.new(raw_message)

    hl7_message = %HL7.Message{
      raw: raw_message,
      separators: separators,
      created_at: DateTime.utc_now()
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
        message_type_and_trigger_event,
        _,
        _,
        hl7_version
      ],
      msh
    )

    message_type = message_type_and_trigger_event |> get_value(0, 0)
    trigger_event = message_type_and_trigger_event |> get_value(0, 1)

    %HL7.Message{
      hl7_message
      | facility: facility |> get_value(),
        message_date_time: message_date_time |> get_value(),
        message_type: message_type,
        trigger_event: trigger_event,
        hl7_version: hl7_version |> get_value(),
        created_at: DateTime.utc_now()
    }
  end

  def new(segments) when is_list(segments) do
    [msh | other_segments] = segments
    [name, field_separator | msh_tail] = msh
    [encoding_characters | _] = msh_tail
    msh_without_field_separator = [name | msh_tail]

    [component, repeat, _escape_char, subcomponent] = String.graphemes(encoding_characters)

    join_by_character_list = [field_separator, repeat, component, subcomponent]

    raw =
      join_with_separators(
        [msh_without_field_separator | other_segments],
        [@segment_terminator | join_by_character_list]
      ) <> @segment_terminator

    HL7.Message.parse(raw)
  end

  def new(raw_message) when is_binary(raw_message) do
    %HL7.InvalidMessage{
      raw: raw_message,
      created_at: DateTime.utc_now()
    }
  end

  @doc """
  Creates an `HL7.Message` struct with parsed segment list data. It will
  extract basic header information (e.g. encoding characters, message type)
  and hold the raw HL7 for further processing.

  If constructed with lists of segment data, it will generate the raw content
  as well the parsed list data.

  Invalid MSH information will return an `HL7.InvalidMessage` struct.
  """
  @spec parse(content_or_valid_hl7()) :: message_struct()
  def parse(%HL7.Message{raw: raw_message, lists: nil, separators: separators} = hl7_message) do
    lists =
      raw_message
      |> String.split(@segment_terminator, trim: true)
      |> Enum.map(&split_segment_text(&1, separators))

    %HL7.Message{hl7_message | lists: lists}
  end

  def parse(%HL7.Message{} = msg) do
    msg
  end

  def parse(raw_message) when is_binary(raw_message) do
    raw_message
    |> HL7.Message.new()
    |> HL7.Message.parse()
  end

  def parse(segments) when is_list(segments) do
    segments
    |> HL7.Message.new()
  end

  @doc """
  Returns a parsed list of segments from an HL7 message or content.
  """
  @spec get_segments(content_or_valid_hl7()) :: [list()]
  def get_segments(msg) when (is_binary(msg) or is_list(msg)) do
    msg
    |> HL7.Message.parse()
    |> Map.get(:lists)
  end

  def get_segments(%HL7.Message{} = msg) do
    msg
    |> HL7.Message.parse()
    |> Map.get(:lists)
  end


  @doc """
  Returns the first parsed segment matching `segment_name` from an HL7 message or content.
  """

  @spec get_segment(content_or_valid_hl7(), String.t()) :: list()
  def get_segment(%HL7.Message{} = msg, segment_name) when is_binary(segment_name) do
    msg |> get_segments() |> get_segment(segment_name)
  end

  def get_segment(raw_msg, segment_name) when is_binary(raw_msg) and is_binary(segment_name) do
    raw_msg |> get_segments() |> get_segment(segment_name)
  end

  @spec get_segment(segment_list :: [list()], segment_name :: String.t()) :: list()
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

  @spec get_segment_parts(content_or_valid_hl7(), segment_name :: String.t()) :: list()

  def get_segment_parts(raw_msg, indices) when is_binary(raw_msg) and is_list(indices) do
    raw_msg
    |> get_segments()
    |> get_segment_parts(indices)
  end

  def get_segment_parts(%HL7.Message{} = hl7_msg, indices) when is_list(indices) do
    hl7_msg
    |> get_segments()
    |> get_segment_parts(indices)
  end

  def get_segment_parts(segments, [<<segment_name::binary-size(3)>> | indices]) when is_list(segments) do
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

  @spec get_segment_part(content_or_valid_hl7(), list()) :: list() | String.t() | nil

  def get_segment_part(raw_msg, indices) when is_binary(raw_msg) and is_list(indices) do
    raw_msg
    |> get_segments()
    |> get_segment_part(indices)
  end

  def get_segment_part(%HL7.Message{} = hl7_msg, indices) when is_list(indices) do
    hl7_msg
    |> get_segments()
    |> get_segment_part(indices)
  end

  def get_segment_part(segments, [<<segment_name::binary-size(3)>> | indices]) when is_list(segments) do
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

  def update_part(data, [], transform) when is_list(transform) or is_binary(transform) do
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

  @spec get_part(hl7_msg :: HL7.Message.t(), indices :: list()) :: nil | list() | binary()
  def get_part(%HL7.Message{} = hl7_message, [segment | indices])
      when is_list(indices) and is_binary(segment) do
    hl7_message
    |> parse()
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
          hl7_msg :: String.t() | [list()] | HL7.Message.t(),
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

  defp get_raw_msh_segment(<<"MSH", _::binary()>> = raw_message) do
    raw_message
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

#  defp split_into_repetitions("", _separators) do
#    ""
#  end
#
#  defp split_into_repetitions(text, separators) do
#    text
#    |> String.split(separators.field_repeat)
#    |> Enum.map(&split_into_components(&1, separators))
#  end
#
#  defp split_into_components("", _separators) do
#    ""
#  end
#
#  defp split_into_components(text, separators) do
#    text
#    |> String.contains?(separators.component)
#    |> case do
#        true ->
#          text
#          |> String.split(separators.component)
#          |> Enum.map(&split_into_subcomponents(&1, separators))
#        false -> text
#       end
#  end
#
#  defp split_into_subcomponents("", _separators) do
#    ""
#  end
#
#  defp split_into_subcomponents(text, separators) do
#    text
#    |> String.contains?(separators.subcomponent)
#    |> case do
#         true ->
#           text
#           |> String.split(separators.subcomponent)
#         false -> text
#       end
#  end

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

    def to_string(%HL7.Message{} = hl7_message) do
      hl7_message.raw
    end
  end
end
