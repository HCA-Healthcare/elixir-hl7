defmodule HL7 do
  @moduledoc """

  Struct and functions for handling HL7 messages (see: [HL7 on Wikipedia](https://en.wikipedia.org/wiki/Health_Level_7)).

  This library specifically handles version 2.x of HL7 as it is by far the most prevalent format in production.

  Since HL7 messages often lack critical contextual metadata, this struct contains a `tags` field for metadata support.

  > ### Tip {: .tip}
  > To migrate from the deprecated `HL7.Message` struct, use `HL7.new/2` and `HL7.Message.new/2` to transform one
  > struct to the other while preserving associated metadata tags.

  Use `HL7.new/2` to convert HL7 text to a parsed HL7 struct.

  To see the parsed representation, try `get_segments/1`.

  To query or update HL7 data, use the `sigil_p` macro to provide an `HL7.Path` with compile-time guarantees.
  For dynamic path access, use `HL7.Path.new/1` to construct paths on the fly.
  HL7 path formats have been designed to reflect common industry usage.

  The `get/2`, `put/3`, and `update/4` functions are designed to query and manipulate HL7 data as an HL7 struct (containing a message),
  a list of segments, a single segment, a list of repetitions, or a single repetition. These should handle data as
  nested lists (automatically converted to 1-indexed maps), nested sparse maps (1-indexed), simple strings, or mixes of each.

  Use `set_segments/2` to fully update an HL7 message.

  """

  defstruct segments: [], tags: %{}

  @buffer_size 32768
  @type file_type_hl7 :: :mllp | :line | nil

  @type hl7_map_data() :: %{optional(non_neg_integer) => hl7_map_data() | String.t()}
  @type hl7_list_data() :: String.t() | [hl7_list_data()]

  @type segment() :: %{
          0 => String.t(),
          optional(pos_integer) => hl7_map_data() | String.t()
        }

  @type t() :: %__MODULE__{tags: map(), segments: [segment()]}

  @type parsed_hl7_segments :: t() | [segment()]
  @type parsed_hl7 :: t() | segment() | [segment()] | hl7_map_data()

  alias HL7.Path

  @doc ~S"""
  The `~p` sigil encodes an HL7 path into a struct at compile-time to guarantee correctness and speed.
  It is designed to work with data returned by `HL7.new!/1`, providing a standard way to get and update
  HL7 message content.

  > ### Tip {: .tip}
  > Use `import HL7, only: :sigils` to access the `~p` sigil without importing other `HL7` functions.

  The full path structure in HL7 is expressed as:

  `~p"SEGMENT_NAME[SEGMENT_NUMBER]-FIELD[REPETITION].COMPONENT.SUBCOMPONENT`

  A trailing exclamation mark can be used in the path to the return only the leftmost text at the given level.

  Position Name | Valid Values
  ------------ | -------------
  `SEGMENT_NAME` | 3 character string
  `SEGMENT_NUMBER` | Positive integer in square brackets, defaults to 1. All segments of `SEGMENT_NAME` can be accessed with `[*]`
  `FIELD` | Positive integer
  `REPETITION` | Positive integer in square brackets, defaults to 1. All repetitions of the `FIELD` can be accessed with `[*]`
  `COMPONENT` | Positive integer
  `SUBCOMPONENT` | Positive integer

  > ### Caution {: .warning}
  > To match industry expectations, HL7 uses 1-based indexes.
  > As noted above, it also includes defaults whereby paths refer to the 1st segment and/or 1st repetition
  > of any query unless explicitly specified.

  Example paths:

     HL7 Path | Description
  `~p"OBX"` | The 1st OBX segment in its entirety, the same as `~p"OBX[1]"`.
  `~p"OBX-5"` | The 1st repetition of the 5th field of the 1st OBX segment.
  `~p"OBX[1]-5[1]"` | Same as above. The numbers in brackets specify the default repetition and segment number values.
  `~p"OBX-5[*]"` | Every repetition of the 5th field of the 1st OBX segment, returning a list of results.
  `~p"OBX[2]-5"` | The 1st repetition of the 5th field of the 2nd OBX segment.
  `~p"OBX[*]-5"` | The 1st repetition of the 5th field of every OBX segment, returning a list of results.
  `~p"OBX[*]-5[*]"` | Every repetition of the 5th field of every OBX segment, returning a nested list of results.
  `~p"OBX-5.2"` | The 2nd component of the 1st repetition of the 5th field of the 1st OBX segment.
  `~p"OBX-5.2.3"` | The 3rd subcomponent of the 2nd component of the 1st repetition of the 5th field of the 1st OBX segment.
  `~p"OBX[*]-5.2.3"` | Same as above, but returned as a list with a value for each OBX segment.
  `~p"OBX[*]-5[*].2.3"` | Same as above, but now a nested list of results for each repetition within each segment.
  `~p"OBX-5!"` | The `!` will take the first text (leftmost value) at whatever level is specified. Thus, `p"OBX-5!"` is equivalent to `p"OBX-5.1.1"`.

  Note that repetitions are uncommon in HL7 and the default of a 1st repetition is often just assumed.
  `~p"PID-3"` is equivalent to `~p"PID-3[1]"` and is the most standard representation.

  All repetitions can be found using a repetition wildcard: `~p"PID-11[*]"`. A list of lists can
  be produced by selecting multiple segments and multiple repetitions with `~p"PID[*]-11[*]"`.

  Components and subcomponents can also be accessed with the path structures.
  `p"OBX-2.3.1"` would return the 1st subcomponent of the 3rd component of the 2nd field of the 1st OBX.

  Additionally, if a path might have additional data such that a string might be found at either
  `~p"OBX-2"` or `~p"OBX-2.1"` or even `~p"OBX-2.1.1"`, there is truncation character (`!`) that
  will return the first element found in the HL7 text at the target specificity. Thus, `~p"OBX[*]-2!"`
  would get the 1st piece of data in the 2nd field of every OBX whether it is a string or nested map.

  > ### Tip {: .tip}
  > Paths that query beyond the content of an HL7 document, e.g. asking for the 10th field of a segment with five fields,
  > will return `nil` as opposed to empty string to indicate that the data does not exist. Adding the
  > trailing `!` will force all return values to be simple strings in cases where `nil` is not desired.

  Lastly, when accessing data from a specific repetition, the path should begin with `.`; for example,
  when working with the Nth OBX segment and using `HL7.get/2` to access that segment's second field, first
  component, use the path `~p".2.1"`

  ## Examples

      iex> import HL7, only: :sigils
      iex> HL7.Examples.wikipedia_sample_hl7() |> HL7.new!() |> HL7.get(~p"OBX-5")
      "1.80"

      iex> import HL7
      iex> HL7.Examples.wikipedia_sample_hl7() |> new!() |> get(~p"OBX-3")
      %{2 => "Body Height"}

      iex> import HL7
      iex> HL7.Examples.wikipedia_sample_hl7() |> new!() |> get(~p"PID-11!")
      "260 GOODWIN CREST DRIVE"

      iex> import HL7
      iex> HL7.Examples.wikipedia_sample_hl7() |> new!() |> get(~p"OBX[*]-5")
      ["1.80", "79"]

      iex> import HL7
      iex> HL7.Examples.wikipedia_sample_hl7() |> new!() |> get(~p"OBX[*]-2!")
      ["N", "NM"]

      iex> import HL7
      iex> HL7.Examples.wikipedia_sample_hl7() |> new!() |> get(~p"PID-11[*].5")
      ["35209", "35200"]

      iex> import HL7
      iex> HL7.Examples.wikipedia_sample_hl7() |> new!() |> get(~p"PID[*]-11[*].5")
      [["35209", "35200"]]

      iex> import HL7
      iex> HL7.Examples.wikipedia_sample_hl7() |> new!() |> get(~p"PID-11[2].1")
      "NICKELL’S PICKLES"

      iex> import HL7
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> new!()
      ...> |> get(~p"PID-11[*]")
      ...> |> List.last()
      ...> |> get(~p".1")
      "NICKELL’S PICKLES"

  """

  defmacro sigil_p({:<<>>, _, [path]}, _modifiers) do
    path
    |> HL7.Path.new()
    |> Macro.escape()
  end

  @doc ~S"""
  Creates an HL7 struct from HL7 data (accepting text, lists or the deprecated `HL7.Message` struct).
  """
  @spec new!(list() | String.t() | HL7.Message.t(), Keyword.t()) :: t()
  def new!(message_content, options \\ []) do
    do_new!(message_content, apply_default_options(message_content, options))
  end

  @spec do_new!(list() | String.t() | HL7.Message.t(), Keyword.t()) :: t()
  defp do_new!(segments, options) when is_list(segments) do
    segments =
      Enum.map(
        segments,
        fn
          segment when is_list(segment) -> to_map(%{}, 0, segment)
          %{0 => _} = segment -> segment
        end
      )

    %__MODULE__{segments: segments, tags: options[:tags] || %{}}
  end

  defp do_new!(text, options) when is_binary(text) do
    text |> HL7.Message.to_list() |> new!(options)
  end

  defp do_new!(%HL7.Message{} = message, options) do
    message |> HL7.Message.to_list() |> new!(options)
  end

  @spec new(String.t(), Keyword.t()) :: {:ok, t()} | {:error, HL7.InvalidMessage.t()}
  def new(text, options \\ []) when is_binary(text) do
    case HL7.Message.new(text, Keyword.take(options, [:copy, :validate_string]) |> Map.new()) do
      %HL7.Message{} = message ->
      {:ok, HL7.new!(message, options)}
      invalid_message -> {:error, invalid_message}
    end
  end

  @spec put(parsed_hl7(), Path.t(), String.t() | nil | hl7_map_data()) :: parsed_hl7()
  def put(%HL7{segments: segments} = hl7, %Path{} = path, value) do
    %HL7{hl7 | segments: put(segments, path, value)}
  end

  def put(segment_data, %Path{} = path, value) do
    segment_data |> do_put(path, value)
  end

  def update(%HL7{segments: segments} = hl7, %Path{} = path, default, fun) do
    %HL7{hl7 | segments: update(segments, path, default, fun)}
  end

  def update(segment_data, path, default, fun) do
    segment_data |> do_put(path, {default, fun})
  end

  def update!(%HL7{segments: segments} = hl7, %Path{} = path, fun) do
    %HL7{hl7 | segments: update!(segments, path, fun)}
  end

  def update!(segment_data, path, fun) do
    segment_data |> do_put(path, {fun})
  end

  def get_segments(%HL7{segments: segments}) do
    segments
  end

  def set_segments(%HL7{} = hl7, segments) do
    %HL7{hl7 | segments: segments}
  end

  def new_segment(<<segment_name::binary-size(3)>>) do
    %{0 => segment_name}
  end


  def format(%HL7{} = hl7, options \\ []) do
    to_string(hl7)
  end

  @doc ~S"""
  Labels source data (a segment map or list of segment maps) by using `HL7.Path` sigils in a labeled
  output template.

  One-arity functions placed as output template values will be called with the source data.

  ## Examples

      iex> import HL7, only: :sigils
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.new!()
      ...> |> HL7.label(%{mrn: ~p"PID-3!", name: ~p"PID-5.2"})
      %{mrn: "56782445", name: "BARRY"}

  """
  @spec label(t() | segment(), map()) :: map()
  def label(segment_or_segments, template_map) do
    for {key, output_param} <- template_map, into: Map.new() do
      {key, do_label(segment_or_segments, output_param) |> nil_for_empty()}
    end
  end

  @doc ~S"""
  Finds data within an `HL7.t()` and from within the data that `get/2` returns (segments and repetitions)
  using an `HL7.Path` sigil.

  Selecting data across multiple segments or repetitions with the wildcard `[*]` pattern
  will return a list of results.

  Repetition data can be search using a partial path containing ony the component and/or
  subcomponent with the preceding period, e.g. `~p".2.3"`.

  ## Examples

      iex> import HL7, only: :sigils
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.new!()
      ...> |> HL7.get(~p"OBX-5")
      "1.80"

      iex> import HL7, only: :sigils
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.new!()
      ...> |> HL7.get(~p"OBX[*]-5")
      ["1.80", "79"]

      iex> import HL7, only: :sigils
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.new!()
      ...> |> HL7.get(~p"OBX[*]-2!")
      ["N", "NM"]

      iex> import HL7, only: :sigils
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.new!()
      ...> |> HL7.get(~p"PID-11[*].5")
      ["35209", "35200"]

      iex> import HL7, only: :sigils
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.new!()
      ...> |> HL7.get(~p"PID-11[2].1")
      "NICKELL’S PICKLES"

      iex> import HL7, only: :sigils
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.new!()
      ...> |> HL7.get(~p"PID-11[*]")
      ...> |> HL7.get(~p".1")
      ["260 GOODWIN CREST DRIVE", "NICKELL’S PICKLES"]

      iex> import HL7
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.new!()
      ...> |> HL7.get(~p"OBX[*]")
      [
        %{
          0 => "OBX",
          1 => "1",
          2 => %{1 => %{1 => "N", 2 => %{1 => "K", 2 => "M"}}},
          3 => %{1 => %{2 => "Body Height"}},
          5 => "1.80",
          6 => %{1 => %{1 => "m", 2 => "Meter", 3 => "ISO+"}},
          11 => "F"
        },
        %{
          0 => "OBX",
          1 => "2",
          2 => "NM",
          3 => %{1 => %{2 => "Body Weight"}},
          5 => "79",
          6 => %{1 => %{1 => "kg", 2 => "Kilogram", 3 => "ISO+"}},
          11 => "F"
        }
      ]
  """

  @spec get(parsed_hl7(), Path.t()) :: hl7_map_data() | [hl7_map_data()] | String.t() | nil
  def get(data, path) do
    data
    |> do_get(path)
    |> maybe_truncate(path)
  end

  @doc """
  Creates a list of lists in which the specified `segment_name` is used to get the first segment map
  of each list. This function helps to do things like grouping `OBX` segments with their parent `OBR` segment.

  Options:

  `keep_prefix_segments: true` will leave the first set of non-matching segments in the return value.
  """
  @spec chunk_by_lead_segment(t() | [segment()], String.t(), Keyword.t()) :: [[segment()]]
  def chunk_by_lead_segment(segments, segment_name, options \\ []) do
    do_chunk_by_segment(segments, segment_name)
    |> maybe_keep_prefix_segments(!!options[:keep_prefix_segments])
  end

  @doc """
  Converts a segment map (or lists of segments maps) or HL7 struct into a raw Elixir list.
  """
  @spec to_list(t() | hl7_map_data()) :: hl7_list_data()
  def to_list(%HL7{segments: segments}) do
    to_list(segments)
  end

  def to_list(map_data) when is_list(map_data) do
    Enum.map(map_data, fn segment_map -> do_to_list(segment_map) end)
  end

  def to_list(map_data) when is_map(map_data) do
    do_to_list(map_data)
  end

  @doc """
  Opens an HL7 file stream of either `:mllp` or `:line`. If the file_type is not specified
  it will be inferred from the first three characters of the file contents.
  """
  @spec open_hl7_file_stream(String.t(), file_type_hl7()) :: Enumerable.t()

  def open_hl7_file_stream(file_path, file_type \\ nil) when is_atom(file_type) do
    found_file_type =
      file_type
      |> case do
        nil ->
          infer_file_type(file_path)

        _ ->
          if File.exists?(file_path) do
            {:ok, file_type}
          else
            {:error, :enoent}
          end
      end

    found_file_type
    |> case do
      {:ok, :line} ->
        file_path
        |> File.stream!(:line)

      {:ok, :mllp} ->
        file_path
        |> File.stream!(@buffer_size)
        |> HL7.MLLPStream.raw_to_messages()

      {:error, reason} ->
        {:error, reason}
    end
  end

  # internals

  defp get_max_index(data) when is_map(data) do
    data |> Map.keys() |> Enum.max() |> max(0)
  end

  defp to_map(value) when is_binary(value) do
    value
  end

  defp to_map(value) when is_list(value) do
    to_map(%{}, 1, value)
  end

  defp to_map(acc, index, [h]) do
    Map.put(acc, index, to_map(h))
  end

  defp to_map(acc, index, [h | t]) do
    case to_map(h) do
      "" -> acc
      v -> Map.put(acc, index, v)
    end
    |> to_map(index + 1, t)
  end

  defp do_to_list(hl7_map_data) when is_binary(hl7_map_data) do
    hl7_map_data
  end

  defp do_to_list(hl7_map_data) do
    do_to_list([], hl7_map_data, get_max_index(hl7_map_data))
  end

  defp do_to_list(acc, %{0 => _} = hl7_map_data, index) when index > -1 do
    chunk = hl7_map_data[index] || ""
    do_to_list([do_to_list(chunk) | acc], hl7_map_data, index - 1)
  end

  defp do_to_list(acc, hl7_map_data, index) when index > 0 do
    chunk = hl7_map_data[index] || ""
    do_to_list([do_to_list(chunk) | acc], hl7_map_data, index - 1)
  end

  defp do_to_list(acc, _hl7_map_data, _index) do
    acc
  end

  defp do_chunk_by_segment(%HL7{segments: segment_list}, segment_name) do
    do_chunk_by_segment([], [], segment_list, segment_name)
  end

  defp do_chunk_by_segment(segment_list, segment_name) when is_list(segment_list) do
    do_chunk_by_segment([], [], segment_list, segment_name)
  end

  defp do_chunk_by_segment([], [], [%{0 => segment_name} = segment | rest], segment_name) do
    do_chunk_by_segment([], [segment], rest, segment_name)
  end

  defp do_chunk_by_segment(
         acc,
         chunk_acc,
         [%{0 => segment_name} = segment | rest],
         segment_name
       ) do
    do_chunk_by_segment([chunk_acc | acc], [segment], rest, segment_name)
  end

  defp do_chunk_by_segment(acc, chunk_acc, [segment | rest], segment_name) do
    do_chunk_by_segment(acc, [segment | chunk_acc], rest, segment_name)
  end

  defp do_chunk_by_segment(acc, chunk_acc, [], _segment_name) do
    [chunk_acc | acc]
    |> Enum.map(&Enum.reverse/1)
    |> Enum.reverse()
  end

  defp get_value_at_index(nil, _) do
    nil
  end

  defp get_value_at_index(segment_data, 1) when is_binary(segment_data) do
    segment_data
  end

  defp get_value_at_index(segment_data, nil) when is_binary(segment_data) do
    segment_data
  end

  defp get_value_at_index(segment_data, _) when is_binary(segment_data) do
    nil
  end

  defp get_value_at_index(segment_data, i) do
    max_index = get_max_index(segment_data)
    if i > max_index, do: nil, else: Map.get(segment_data, i, "")
  end

  defp ensure_map(data) when is_binary(data) or is_nil(data) do
    %{1 => data}
  end

  defp ensure_map(data) when is_map(data) do
    data
  end

  defp maybe_truncate(nil, %Path{truncate: true}) do
    ""
  end

  defp maybe_truncate(segment_data, %Path{truncate: true}) do
    truncate(segment_data)
  end

  defp maybe_truncate(segment_data, %Path{truncate: false}) do
    segment_data
  end

  defp truncate(segment_data) when is_binary(segment_data) or is_nil(segment_data) do
    segment_data
  end

  defp truncate(segment_data) when is_map(segment_data) do
    get_value_at_index(segment_data, 1)
    |> truncate()
  end

  defp truncate(segment_data) when is_list(segment_data) do
    Enum.map(segment_data, &truncate/1)
  end

  defp resolve_placement_value(_field_data = nil, {default, _fun}, _path) do
    default |> lists_become_maps()
  end

  defp resolve_placement_value(field_data, {_default, fun}, _path) do
    fun.(field_data) |> lists_become_maps()
  end

  defp resolve_placement_value(_field_data = nil, {_fun}, path) do
    raise KeyError, message: "HL7.Path #{inspect(path)} could not be found"
  end

  defp resolve_placement_value(field_data, {fun}, _path) do
    fun.(field_data) |> lists_become_maps()
  end

  defp resolve_placement_value(_field_data, value, _path) do
    value |> lists_become_maps()
  end

  defp lists_become_maps(value) when is_list(value) do
    value
    |> Enum.with_index()
    |> Map.new(fn {v, i} -> {i + 1, lists_become_maps(v)} end)
  end

  defp lists_become_maps(value), do: value

  defp do_get(%HL7{} = hl7, %Path{} = path) do
    do_get(hl7.segments, path)
  end

  defp do_get([], %Path{} = _path) do
    []
  end

  defp do_get([%{0 => _} | _] = _segments, %Path{segment: nil} = path) do
    raise RuntimeError,
          "`HL7.Path` to get data across multiple segments must include a segment name, not #{inspect(path)}"
  end

  # from multiple segments, return a result for each segment in a list
  defp do_get([%{0 => _} | _] = segments, %Path{segment: name, segment_number: "*"} = path) do
    segments
    |> Stream.filter(&(&1[0] == name))
    |> Enum.map(&do_get_in_segment(&1, path))
  end

  # from multiple segments, return a result for a specific segment
  defp do_get([%{0 => _} | _] = segments, %Path{segment: name, segment_number: n} = path) do
    segments
    |> Stream.filter(&(&1[0] == name))
    |> Stream.drop(n - 1)
    |> Enum.at(0)
    |> do_get_in_segment(path)
  end

  defp do_get(nil = _segment_data, _path) do
    nil
  end

  # for a single segment
  defp do_get(%{0 => _} = segment_data, path) do
    do_get_in_segment(segment_data, path)
  end

  # for a list of repetitions (generally a repeating field), return a result for each
  defp do_get(repetition_list, %{field: nil, repetition: nil} = path)
       when is_list(repetition_list) do
    Enum.map(repetition_list, &do_get_in_repetition(&1, path))
  end

  # for a single repetition in a field
  defp do_get(repetition_data, %{field: nil, repetition: nil} = path) do
    do_get_in_repetition(repetition_data, path)
  end

  defp do_get(_repetition_data, path) do
    raise RuntimeError,
          "HL7.Path #{inspect(path)} could not work with the given data."
  end

  defp do_get_in_segment(segment_data, %{field: nil, component: nil} = _path) do
    segment_data
  end

  defp do_get_in_segment(_segment_data, %{field: nil} = path) do
    raise RuntimeError,
          "HL7.Path #{inspect(path)} requires field number."
  end

  defp do_get_in_segment(segment_data, %{field: f} = path) do
    segment_data
    |> get_value_at_index(f)
    |> do_get_in_field(path)
  end

  defp do_get_in_field(field_data, %{repetition: "*"} = path) when is_map(field_data) do
    1..get_max_index(field_data)
    |> Enum.map(fn r ->
      field_data
      |> get_value_at_index(r)
      |> do_get_in_repetition(path)
    end)
  end

  defp do_get_in_field(field_data, %{repetition: "*"}) do
    [field_data]
  end

  defp do_get_in_field(field_data, %{repetition: r} = path) do
    field_data
    |> get_value_at_index(r)
    |> do_get_in_repetition(path)
  end

  defp do_get_in_repetition(repetition_data, %{component: nil}) do
    repetition_data
  end

  defp do_get_in_repetition(repetition_data, %{component: c} = path) do
    repetition_data
    |> get_value_at_index(c)
    |> do_get_in_component(path)
  end

  defp do_get_in_component(component_data, %{subcomponent: nil}) do
    component_data
  end

  defp do_get_in_component(component_data, %{subcomponent: s}) do
    component_data
    |> get_value_at_index(s)
  end

  # put across multiple segments
  defp do_put([%{0 => _} | _] = segments, %Path{segment: name, segment_number: "*"} = path, value) do
    segments
    |> Enum.map(fn segment ->
      if segment[0] == name, do: do_put_in_segment(segment, value, path), else: segment
    end)
  end

  # put within a specific segment
  defp do_put([%{0 => _} | _] = segments, %Path{segment: name, segment_number: n} = path, value) do
    segments
    |> Stream.with_index()
    |> Stream.filter(&(elem(&1, 0)[0] == name))
    |> Stream.drop(n - 1)
    |> Enum.at(0)
    |> case do
      {segment_data, index} ->
        List.replace_at(segments, index, do_put_in_segment(segment_data, value, path))

      nil ->
        raise RuntimeError, "HL7.Path #{inspect(path)} has no matching segment."
    end
  end

  defp do_put(%{0 => _} = segment_data, path, value) do
    do_put_in_segment(segment_data, value, path)
  end

  defp do_put(repetition_list, %{field: nil, repetition: nil} = path, value)
       when is_list(repetition_list) do
    Enum.map(repetition_list, &do_put_in_repetition(&1, value, path))

  end

  defp do_put(repetition_data, %{field: nil, repetition: nil} = path, value) do
    do_put_in_repetition(repetition_data, value, path)
  end

  defp do_put(_repetition_data, path, _value) do
    raise RuntimeError,
          "HL7.Path #{inspect(path)} to update repetition data should be begin with `.`"
  end

  defp do_put_in_segment(segment_data, value, %{field: nil} = path) do
    resolve_placement_value(segment_data, value, path)
  end

  defp do_put_in_segment(segment_data, value, %{field: f} = path) do
    Map.put(segment_data, f, do_put_in_field(segment_data[f], value, path))
  end

  # data can contain either simple strings or maps by ordinal index
  # if a map contains only one string, it is reduced here to the string value alone

  defp simplify_string_fields(value) do
    do_simplify_string_fields(value, value)
  end

  defp do_simplify_string_fields(original, %{1 => value} = map) when map_size(map) == 1 do
    do_simplify_string_fields(original, value)
  end

  defp do_simplify_string_fields(_original, value) when is_binary(value) do
    value
  end

  defp do_simplify_string_fields(original, _value) do
    original
  end

  defp do_put_in_field(field_data, value, %{repetition: "*", component: nil} = path) do
    resolve_placement_value(field_data, value, path)
    |> simplify_string_fields()
  end

  defp do_put_in_field(field_data, value, %{repetition: "*"} = path) do
    1..get_max_index(field_data)
    |> Map.new(fn i ->
      {i, do_put_in_repetition(ensure_map(field_data[i]), value, path)}
    end)
    |> simplify_string_fields()
  end

  defp do_put_in_field(field_data, value, %{repetition: r} = path) do
    field_map = ensure_map(field_data)

    Map.put(field_map, r, do_put_in_repetition(field_map[r], value, path))
    |> simplify_string_fields()
  end

  defp do_put_in_repetition(repetition_data, value, %{component: nil} = path) do
    resolve_placement_value(repetition_data, value, path)
    |> simplify_string_fields()
  end

  defp do_put_in_repetition(repetition_data, value, %{component: c} = path) do
    repetition_map = ensure_map(repetition_data)
    Map.put(repetition_map, c, do_put_in_component(repetition_map[c], value, path))
  end

  defp do_put_in_component(component_data, value, %{subcomponent: nil} = path) do
    resolve_placement_value(component_data, value, path)
    |> simplify_string_fields()
  end

  defp do_put_in_component(subcomponent_data, value, %{subcomponent: s} = path) do
    subcomponent_map = ensure_map(subcomponent_data)
    Map.put(subcomponent_map, s, resolve_placement_value(subcomponent_map[s], value, path))
  end

  defp do_label(segment_data, %Path{} = output_param) do
    get(segment_data, output_param)
  end

  defp do_label(segment_data, output_param) when is_map(output_param) do
    label(segment_data, output_param)
  end

  defp do_label(segment_data, list) when is_list(list) do
    Enum.map(list, &do_label(segment_data, &1))
  end

  defp do_label(segment_data, function) when is_function(function, 1) do
    function.(segment_data)
  end

  defp do_label(_segment_data, value) do
    value |> nil_for_empty()
  end

  defp maybe_keep_prefix_segments(segment_chunks, true) do
    segment_chunks
  end

  defp maybe_keep_prefix_segments([_prefix_segments | segment_chunks], false) do
    segment_chunks
  end

  defp nil_for_empty(""), do: nil
  defp nil_for_empty(value), do: value

  @spec apply_default_options(list() | String.t() | HL7.Message.t(), Keyword.t()) :: Keyword.t()
  defp apply_default_options(%HL7.Message{tag: tags} = _message_content, options) do
    [tags: tags, copy: options[:copy]]
  end

  defp apply_default_options(_message_content, options) do
    [tags: options[:tags] || %{}, copy: options[:copy]]
  end

  @spec infer_file_type(String.t()) :: {:ok, :line} | {:ok, :mllp} | {:error, atom()}
  defp infer_file_type(file_path) do
    File.open(file_path, [:read])
    |> case do
      {:ok, file_ref} ->
        first_three = IO.binread(file_ref, 3)
        _ = File.close(file_ref)

        case first_three do
          <<"MSH">> ->
            {:ok, :line}

          <<0x0B, "M", "S">> ->
            {:ok, :mllp}

          _ ->
            {:error, :unrecognized_file_type}
        end

      error ->
        error
    end
  end
end

defimpl Inspect, for: HL7 do
  def inspect(%HL7{segments: segments} = _hl7, _opts) do
    case Enum.count(segments) do
      1 -> "#HL7[with 1 segment]"
      c -> "#HL7[with #{c} segments]"
    end
  end
end

defimpl String.Chars, for: HL7 do
  @spec to_string(HL7.t()) :: String.t()
  def to_string(%HL7{} = hl7) do
    hl7 |> HL7.to_list() |> HL7.Message.raw() |> Map.get(:raw)
  end
end
