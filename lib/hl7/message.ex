defmodule HL7.Message do
  require Logger

  @moduledoc """
  Creates, parses and modifies HL7 messages with a focus on performance. Contains a list of parsed segments and header metadata.

  Use `Hl7.Message.new/1` to create an `Hl7.Message` struct that contains a fully parsed HL7 message alongside header metadata.
  The parsed data is represented as minimally as possible as lists of string and lists.
  """

  @segment_terminator "\r"

  @type t :: %HL7.Message{
          segments: nil | list(),
          header: nil | HL7.Header.t()
        }

  @type raw_hl7 :: String.t() | HL7.RawMessage.t()
  @type fragment_hl7 :: String.t() | [list() | String.t()]
  @type segment_hl7 :: [fragment_hl7()]
  @type parsed_hl7 :: [segment_hl7()] | HL7.Message.t()
  @type content_hl7 :: raw_hl7() | parsed_hl7()

  defstruct segments: nil,
            fragments: [],
            header: nil,
            tag: %{}

  @doc """
  Creates an `HL7.Message` struct containing the raw HL7 text for further processing. It will
  also expose basic header information (e.g. encoding characters, message type) for routing.

  Invalid MSH formats will return an `HL7.InvalidMessage` struct.
  """

  @spec raw(content_hl7()) :: HL7.RawMessage.t() | HL7.InvalidMessage.t()
  def raw(
        <<"MSH", field_separator::binary-size(1), _encoding_characters::binary-size(5),
          field_separator::binary-size(1), _::binary()>> = raw_text
      ) do
    parse_raw_hl7(raw_text)
  end

  def raw(
        <<"MSH", field_separator::binary-size(1), _encoding_characters::binary-size(4),
          field_separator::binary-size(1), _::binary()>> = raw_text
      ) do
    parse_raw_hl7(raw_text)
  end

  def raw(segments) when is_list(segments) do
    [msh | other_segments] = segments
    [name, field_separator | msh_tail] = msh
    [encoding_characters | _] = msh_tail
    msh_without_field_separator = [name | msh_tail]

    [component, repeat, _escape_char, subcomponent | _truncation_char] =
      String.graphemes(encoding_characters)

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
      created_at: DateTime.utc_now(),
      reason: :missing_header_or_encoding
    }
  end

  def raw(%HL7.Message{segments: segments}) do
    HL7.Message.raw(segments)
  end

  def raw(%HL7.RawMessage{} = raw_msg) do
    raw_msg
  end

  defp parse_raw_hl7(raw_text) do
    header = extract_header(raw_text)

    case header do
      %HL7.Header{} ->
        %HL7.RawMessage{raw: raw_text, header: header}

      %HL7.InvalidHeader{} ->
        %HL7.InvalidMessage{raw: raw_text, header: header, reason: :invalid_header}
    end
  end

  @doc ~S"""
  Creates an `HL7.Message` struct containing parsed segment list data. It will
  also expose basic header information (e.g. encoding characters, message type) for routing.

  Invalid MSH formats will return an `HL7.InvalidMessage`.

  ## Examples

      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Message.new()
      ...> |> HL7.Query.get_segment_names()
      ["MSH", "EVN", "PID", "PV1", "OBX", "OBX", "AL1", "DG1"]

      iex> HL7.Message.new(
      ...>   "MSH|^~\\&|MegaReg|XYZHospC|SuperOE|XYZImgCtr|" <>
      ...>   "20060529090131-0500||ADT^A01^ADT_A01|01052901|P|2.5")
      ...> |> HL7.Query.get_segment_names()
      ["MSH"]

      iex> HL7.Message.new(
      ...>   [["MSH", "|", "^~\\&", "App", "Facility", "", "",
      ...>     "20060529090131-0500", "", [["ADT", "A01", "ADT_A01"]],
      ...>     "01052901", "P", "2.5"]])
      ...> |> HL7.Query.get_segment_names()
      ["MSH"]

  """
  @spec new(content_hl7() | HL7.Header.t()) :: HL7.Message.t() | HL7.InvalidMessage.t()
  def new(%HL7.RawMessage{raw: raw_text, header: header}) do
    {segments, fragments} =
      raw_text
      |> String.split(@segment_terminator, trim: true)
      |> Enum.split_with(&has_segment_name(&1, header.separators.field))

    parsed_segments = segments |> Enum.map(&split_segment_text(&1, header.separators))

    %HL7.Message{segments: parsed_segments, fragments: fragments, header: header}
  end

  def new(%HL7.Message{} = msg) do
    msg
  end

  def new(%HL7.InvalidMessage{} = msg) do
    msg
  end

  def new(<<"MSH|^~\\&", _rest::binary()>> = raw_text) do
    parsed_segments = HL7.Parser.parse(raw_text)

    {segments, fragments} =
      parsed_segments
      |> Enum.split_with(fn
        [<<_name::binary-size(3)>> | _rest] -> true
        _ -> false
      end)

    header = get_header_from_msh(List.first(segments))
    %HL7.Message{segments: segments, fragments: fragments, header: header}
  end

  def new(<<"MSH|^~\\&#", _rest::binary()>> = raw_text) do
    parsed_segments = HL7.Parser.parse(raw_text)

    {segments, fragments} =
      parsed_segments
      |> Enum.split_with(fn
        [<<_name::binary-size(3)>> | _rest] -> true
        _ -> false
      end)

    header = get_header_from_msh(List.first(segments))
    %HL7.Message{segments: segments, fragments: fragments, header: header}
  end

  def new(raw_text) when is_binary(raw_text) do
    raw_text
    |> HL7.Message.raw()
    |> HL7.Message.new()
  end

  def new(segments) when is_list(segments) do
    %HL7.Message{segments: segments, header: extract_header(segments)}
  end

  def new(%HL7.Header{} = header) do
    msh = HL7.Header.to_msh(header)
    HL7.Message.new([msh])
  end

  @doc """
  Returns a parsed list of segments from an HL7 message or content.
  """
  @spec to_list(content_hl7()) :: [list()]
  def to_list(msg) when is_list(msg) do
    msg
  end

  def to_list(%HL7.Message{segments: segments}) do
    segments
  end

  def to_list(%HL7.RawMessage{} = msg) do
    msg |> HL7.Message.new() |> to_list()
  end

  def to_list(raw_text) when is_binary(raw_text) do
    raw_text |> HL7.Message.new() |> to_list()
  end

  @doc """
  Returns the first parsed segment matching `segment_name` from an HL7 message or content.
  """

  @spec find(content_hl7(), String.t() | non_neg_integer()) :: segment_hl7() | nil

  def find(segments, segment_name)
      when is_list(segments) and is_binary(segment_name) do
    segments
    |> Enum.find(fn segment ->
      [h | _] = segment
      h == segment_name
    end)
  end

  def find(%HL7.Message{segments: segments}, segment_name)
      when is_list(segments) and is_binary(segment_name) do
    segments
    |> find(segment_name)
  end

  def find(%HL7.RawMessage{} = msg, segment_name)
      when is_binary(segment_name) do
    msg
    |> to_list()
    |> find(segment_name)
  end

  def find(raw_text, segment_name)
      when is_binary(raw_text) and is_binary(segment_name) do
    raw_text
    |> to_list()
    |> find(segment_name)
  end

  @doc false

  # utility method for HL7.Query

  @spec update_segments(list(), list(), list() | String.t() | nil | function()) :: list()

  def update_segments(segments, [<<segment_name::binary-size(3)>> | indices], transform) do
    segments
    |> Enum.map(fn
      [^segment_name | _] = segment ->
        HL7.Segment.replace_fragment(segment, indices, transform, true)

      segment ->
        segment
    end)
  end

  def update_segments(segments, indices, transform) do
    segments
    |> Enum.map(fn segment -> HL7.Segment.replace_fragment(segment, indices, transform, true) end)
  end

  # -----------------
  # Private functions
  # -----------------

  @spec get_raw_msh_segment(String.t()) :: String.t()
  defp get_raw_msh_segment(<<"MSH", _::binary()>> = raw_text) do
    raw_text
    |> String.split(@segment_terminator, parts: 2)
    |> Enum.at(0)
  end

  defp has_segment_name(<<name::binary-size(3), field::binary-size(1), _::binary()>>, field) do
    String.match?(name, ~r/^[[:digit:][:upper:]]+$/)
  end

  defp has_segment_name(_, _), do: false

  @spec split_segment_text(String.t(), HL7.Separators.t()) :: list()
  defp split_segment_text(<<"MSH", _rest::binary()>> = raw_text, separators) do
    raw_text
    |> strip_msh_encoding
    |> split_into_fields(separators)
    |> add_msh_encoding_fields(separators)
  end

  defp split_segment_text(raw_text, separators) do
    raw_text |> split_into_fields(separators)
  end

  @spec split_into_fields(String.t(), HL7.Separators.t()) :: list()
  defp split_into_fields(text, separators) do
    text
    |> String.split(separators.field)
    |> Enum.map(&split_with_text_delimiters(&1, separators))
  end

  @spec split_with_text_delimiters(String.t(), HL7.Separators.t()) :: list()
  defp split_with_text_delimiters("", _separators) do
    ""
  end

  defp split_with_text_delimiters(text, separators) do
    delimiters = get_delimiters_in_text(text, separators)
    text |> split_with_separators(delimiters)
  end

  @spec get_delimiters_in_text(String.t(), HL7.Separators.t()) :: list(String.t())
  defp get_delimiters_in_text(text, separators) do
    find_delimiters(text, separators.delimiter_check)
  end

  @spec find_delimiters(String.t(), list(String.t())) :: list(String.t())
  defp find_delimiters(_text, []) do
    []
  end

  defp find_delimiters(text, [split_character | remaining] = delimiters) do
    case text |> String.contains?(split_character) do
      true -> Enum.reverse(delimiters)
      false -> find_delimiters(text, remaining)
    end
  end

  @spec split_with_separators(String.t(), [String.t()]) :: list() | String.t()

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

  @spec unwrap_length_one_lists(list()) :: list() | String.t()
  defp unwrap_length_one_lists(v) do
    case v do
      [text] when is_binary(text) -> text
      _ -> v
    end
  end

  @spec join_with_separators(String.t() | list(), [String.t()]) :: String.t()
  defp join_with_separators(text, separators) when is_binary(text) and is_list(separators) do
    text
  end

  defp join_with_separators(lists, [split_character | remaining_characters]) do
    lists
    |> Enum.map(&join_with_separators(&1, remaining_characters))
    |> Enum.join(split_character)
  end

  @spec strip_msh_encoding(String.t()) :: String.t()
  defp strip_msh_encoding(
         <<"MSH", field_separator::binary-size(1), _encoding_chars::binary-size(4),
           truncation_char::binary-size(1), field_separator::binary-size(1), msh_rest::binary>>
       )
       when truncation_char != field_separator do
    "MSH" <> field_separator <> msh_rest
  end

  defp strip_msh_encoding(<<"MSH", _encoding_chars::binary-size(5), msh_rest::binary>>) do
    "MSH" <> msh_rest
  end

  @spec add_msh_encoding_fields([String.t()], HL7.Separators.t()) :: list()
  defp add_msh_encoding_fields([msh_name | msh_tail], separators) do
    [msh_name, separators.field, separators.encoding_characters | msh_tail]
  end

  @spec extract_header(String.t() | list()) :: HL7.Header.t() | HL7.InvalidHeader.t()
  defp extract_header(raw_text) when is_binary(raw_text) do
    separators = HL7.Separators.new(raw_text)
    msh = raw_text |> get_raw_msh_segment() |> split_segment_text(separators)
    get_header_from_msh(msh)
  end

  defp extract_header(segments) when is_list(segments) do
    msh = HL7.Message.find(segments, "MSH")
    get_header_from_msh(msh)
  end

  defp get_header_from_msh(msh) when is_list(msh) do
    destructure(
      [
        _segment_type,
        field_separator,
        encoding_characters,
        sending_application,
        sending_facility,
        receiving_application,
        receiving_facility,
        message_date_time,
        security,
        message_type_and_trigger_event_content,
        message_control_id,
        processing_id,
        hl7_version
      ],
      msh
    )

    {message_type_valid, message_type_info} =
      get_message_type_info(message_type_and_trigger_event_content)

    case message_type_valid do
      true ->
        {message_type, trigger_event} = message_type_info

        %HL7.Header{
          separators: HL7.Separators.new(field_separator, encoding_characters),
          sending_application: sending_application |> leftmost_value(),
          sending_facility: sending_facility |> leftmost_value(),
          receiving_application: receiving_application |> leftmost_value(),
          receiving_facility: receiving_facility |> leftmost_value(),
          message_date_time: message_date_time |> leftmost_value(),
          message_type: message_type,
          trigger_event: trigger_event,
          security: security,
          message_control_id: message_control_id,
          processing_id: processing_id,
          hl7_version: hl7_version |> leftmost_value()
        }

      false ->
        %HL7.InvalidHeader{raw: msh, reason: message_type_info}
    end
  end

  defp get_header_from_msh(msh) do
    %HL7.InvalidHeader{raw: msh, reason: :unknown_reason}
  end

  defp get_message_type_info(content) do
    case content do
      [[m, t | _] | _] -> {true, {m, t}}
      <<m::binary-size(3)>> -> {true, {m, ""}}
      _ -> {false, :invalid_message_type}
    end
  end

  defp leftmost_value([]) do
    nil
  end

  defp leftmost_value([h | _]) do
    leftmost_value(h)
  end

  defp leftmost_value(d) do
    d
  end

  defimpl String.Chars, for: HL7.Message do
    require Logger

    @spec to_string(HL7.Message.t()) :: String.t()
    def to_string(%HL7.Message{segments: segments}) do
      HL7.Message.raw(segments) |> Map.get(:raw)
    end
  end
end
