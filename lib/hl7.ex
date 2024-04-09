defmodule HL7 do
  @moduledoc """
  Utility functions to load HL7 files as local streams.
  """

  defstruct segments: []

  @buffer_size 32768
  @type file_type_hl7 :: :mllp | :line | nil

  @type hl7_map_data() :: %{
          optional(non_neg_integer) => hl7_map_data() | String.t(),
          e: non_neg_integer()
        }
  @type hl7_list_data() :: String.t() | [hl7_list_data]

  @type segment() :: %{
          0 => String.t(),
          optional(pos_integer) => hl7_map_data() | String.t(),
          e: non_neg_integer()
        }

  @type t() :: %__MODULE__{segments: [segment()]}

  @type parsed_hl7_segments :: t() | [segment()]
  @type parsed_hl7 :: t() | segment() | [segment()] | hl7_map_data()

  alias HL7.Path

  @doc ~S"""
  The `~p` sigil encodes an HL7 path into a struct at compile-time to guarantee correctness and speed.
  It is designed to work with data returned by `HL7.new!/1`.

  `~p"OBX-5"` means the 5th field of the 1st OBX segment.
  `~p"OBX[1]-5"` is equivalent, the number in brackets specifying which segment iteration to target.
  `~p"OBX[2]-5"` thus means the 5th field of the 2nd OBX segment.
  `~p"OBX[*]-5"` would get the 5th field of every OBX segment, returning a list of results.
  `~p"OBX"` by itself refers to the 1st OBX segment in its entirety, same as `~p"OBX[1]"`.

  As some fields contain repetitions in HL7, these can accessed in the same manner.
  `~p"PID-11"` is equivalent to `~p"PID-11[1]"`.
  It would return the first repetition of the 11th field in the first PID segment.
  All repetitions can be found using the wildcard: `~p"PID-11[*]"`.

  Components and subcomponents can also be accessed with the path structures.
  `h"OBX-2.3.1"` would return the 1st subcomponent of the 3rd component of the 2nd field of the 1st OBX.

  Lastly, if a path might have additional data such that a string might be found at either
  `~p"OBX-2"` or `~p"OBX-2.1"` or even `~p"OBX-2.1.1"`, there is truncation character (the bang symbol) that
  will return the first element found in the HL7 text at the target specificity. Thus, `~p"OBX[*]-2!"`
  would get the 1st piece of data in the 2nd field of every OBX whether it is a string or nested map.

  ## Examples

      iex> import HL7
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.new!()
      ...> |> HL7.get(~p"OBX-5")
      "1.80"

      iex> import HL7
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.new!()
      ...> |> HL7.get(~p"OBX[*]-5")
      ["1.80", "79"]

      iex> import HL7
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.new!()
      ...> |> HL7.get(~p"OBX[*]-2!")
      ["N", "NM"]

      iex> import HL7
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.new!()
      ...> |> HL7.get(~p"PID-11[*].5")
      ["35209", "35200"]

      iex> import HL7
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.new!()
      ...> |> HL7.get(~p"PID-11[2].1")
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
  @spec new!(hl7_list_data() | String.t() | HL7.Message.t()) :: t()
  def new!(segments) when is_list(segments) do
    segments = Enum.map(segments, fn segment -> to_map(%{}, 0, segment) end)
    %__MODULE__{segments: segments}
  end

  def new!(text) when is_binary(text) do
    text |> HL7.Message.to_list() |> new!()
  end

  def new!(%HL7.Message{} = message) do
    message |> HL7.Message.to_list() |> new!()
  end

  @spec new(String.t()) :: {:ok, t()} | {:error, HL7.InvalidMessage.t()}
  def new(text) when is_binary(text) do
    case HL7.Message.new(text) do
      %HL7.Message{} = message -> {:ok, message |> HL7.Message.to_list() |> new!()}
      invalid_message -> {:error, invalid_message}
    end
  end

  @spec put(parsed_hl7(), Path.t(), String.t() | nil | hl7_map_data()) :: parsed_hl7()
  def put(segment_data, %Path{} = path, value) do
    segment_data
    |> cap_nested_input_map()
    |> do_put(path, value)
    |> uncap_nested_output_map()
  end

  def update(segment_data, path, default, fun) do
    segment_data
    |> cap_nested_input_map()
    |> do_put(path, {default, fun})
    |> uncap_nested_output_map()
  end

  def update!(segment_data, path, fun) do
    segment_data
    |> cap_nested_input_map()
    |> do_put(path, {fun})
    |> uncap_nested_output_map()
  end

  def get_segments(%HL7{segments: segments}) do
    uncap_nested_output_map(segments)
  end

  def set_segments(%HL7{} = hl7, segments) do
    %HL7{hl7 | segments: cap_nested_input_map(segments)}
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

  """

  @spec get(parsed_hl7(), %Path{}) ::
          hl7_map_data() | String.t() | nil

  def get(data, path) do
    data
    |> do_get(path)
    |> maybe_truncate(path)
    |> uncap_nested_output_map()
  end

  @doc """
  Creates a list of lists in which the specified `segment_name` is used to get the first segment map
  of each list. This function helps to do things like grouping `OBX` segments with their parent `OBR` segment.
  """
  @spec chunk_by_lead_segment(t() | [segment()], String.t()) :: [[segment()]]
  def chunk_by_lead_segment(%HL7{segments: segments}, segment_name) do
    do_chunk_by_segment([], [], segments, segment_name)
  end

  def chunk_by_lead_segment(segment_list, segment_name) do
    do_chunk_by_segment([], [], segment_list, segment_name)
  end

  @doc """
  Rejects Z-segments (those starting with the letter Z, usually custom) from a list of segment maps.
  """
  def reject_z_segments(segment_list) do
    Enum.reject(segment_list, fn segment -> String.at(segment[0], 0) == "Z" end)
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
        |> File.stream!(@buffer_size)

      {:ok, :mllp} ->
        file_path
        |> File.stream!(@buffer_size)
        |> HL7.MLLPStream.raw_to_messages()

      {:error, reason} ->
        {:error, reason}
    end
  end

  # internals

  defp get_max_index(%{__max_index__: max_index}) do
    max_index
  end

  defp get_max_index(data) when is_map(data) do
    data |> Map.keys() |> Enum.max() |> max(1)
  end

  defp cap_map(map, index) do
    Map.put(map, :__max_index__, max(map[:__max_index__] || 1, index))
  end

  defp cap_nested_input_map(%{__max_index__: _} = data) do
    Map.new(data, fn {k, v} -> {k, cap_nested_input_map(v)} end)
  end

  defp cap_nested_input_map(%HL7{segments: segments}) do
    %HL7{segments: Enum.map(segments, &cap_nested_input_map/1)}
  end

  defp cap_nested_input_map(data) when is_map(data) do
    max_index = data |> Map.keys() |> Enum.max() |> max(1)

    data
    |> Map.put(:__max_index__, max_index)
    |> Map.new(fn {k, v} -> {k, cap_nested_input_map(v)} end)
  end

  defp cap_nested_input_map(data) do
    data
  end

  defp uncap_nested_output_map(data) when is_map(data) do
    data
    |> Map.delete(:__max_index__)
    |> Map.new(fn {k, v} -> {k, uncap_nested_output_map(v)} end)
  end

  defp uncap_nested_output_map(data) when is_list(data) do
    Enum.map(data, &uncap_nested_output_map/1)
  end

  defp uncap_nested_output_map(data) do
    data
  end

  defp to_map(value) when is_binary(value) do
    value
  end

  defp to_map(value) when is_list(value) do
    to_map(%{}, 1, value)
  end

  defp to_map(acc, index, []) do
    Map.put(acc, :__max_index__, index - 1)
  end

  defp to_map(acc, index, [h | t]) do
    case to_map(h) do
      "" -> acc
      v -> Map.put(acc, index, v)
    end
    |> to_map(index + 1, t)
  end

  def do_to_list(hl7_map_data) when is_binary(hl7_map_data) do
    hl7_map_data
  end

  def do_to_list(hl7_map_data) do
    do_to_list([], hl7_map_data, hl7_map_data[:__max_index__])
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

  defp do_chunk_by_segment([], [], [_segment | rest], segment_name) do
    do_chunk_by_segment([], [], rest, segment_name)
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

  defp get_value_at_index(%{__max_index__: max_index} = _segment_data, i) when i > max_index do
    nil
  end

  defp get_value_at_index(segment_data, i) do
    Map.get(segment_data, i, "")
  end

  defp ensure_map(data, index) when is_binary(data) or is_nil(data) do
    %{1 => data}
    |> Map.put(:__max_index__, max(1, index))
  end

  defp ensure_map(data, index) when is_map(data) do
    cap_map(data, index)
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
    default |> cap_nested_input_map()
  end

  defp resolve_placement_value(field_data, {_default, fun}, _path) do
    fun.(field_data) |> cap_nested_input_map()
  end

  defp resolve_placement_value(_field_data = nil, {_fun}, path) do
    raise KeyError, message: "HL7.Path #{inspect(path)} could not be found"
  end

  defp resolve_placement_value(field_data, {fun}, _path) do
    fun.(field_data) |> cap_nested_input_map()
  end

  defp resolve_placement_value(_field_data, value, _path) do
    value |> cap_nested_input_map()
  end

  defp do_get(%HL7{} = hl7, %Path{} = path) do
    do_get(hl7.segments, path)
  end

  defp do_get([], %Path{} = _path) do
    []
  end

  defp do_get([%{0 => _} | _] = _segments, %Path{segment: nil} = path) do
    raise RuntimeError,
          "`HL7.Path` to get data across segments must begin with a segment name, not #{inspect(path)}"
  end

  defp do_get([%{0 => _} | _] = segments, %Path{segment: name, segment_number: "*"} = path) do
    segments
    |> Stream.filter(&(&1[0] == name))
    |> Enum.map(&do_get_in_segment(&1, path))
  end

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

  defp do_get(%{0 => _} = segment_data, path) do
    do_get_in_segment(segment_data, path)
  end

  defp do_get(repetition_list, path) when is_list(repetition_list) do
    Enum.map(repetition_list, &do_get_in_repetition(&1, path))
  end

  defp do_get(repetition_data, %{field: nil, repetition: nil} = path) do
    do_get_in_repetition(repetition_data, path)
  end

  defp do_get(_repetition_data, path) do
    raise RuntimeError,
          "HL7.Path to directly access repetitions should be begin with `.`, not #{inspect(path)}"
  end

  defp do_get_in_segment(segment_data, %{field: nil, component: nil} = _path) do
    segment_data
  end

  defp do_get_in_segment(_segment_data, %{field: nil} = path) do
    raise RuntimeError,
          "HL7.Path to access components within segments requires field number, not #{inspect(path)}"
  end

  defp do_get_in_segment(segment_data, %{field: f} = path) do
    do_get_in_field(segment_data[f], path)
  end

  defp do_get_in_field(field_data, %{repetition: "*"} = path) when is_map(field_data) do
    1..get_max_index(field_data)
    |> Enum.map(fn i -> do_get_in_repetition(field_data[i], path) end)
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

  defp do_put(%HL7{} = hl7, %Path{segment: name, segment_number: "*"} = path, value) do
    hl7.segments
    |> Enum.map(fn segment ->
      if segment[0] == name, do: do_put_in_segment(segment, value, path), else: segment
    end)
  end

  defp do_put(%HL7{} = hl7, %Path{segment: name, segment_number: n} = path, value) do
    hl7.segments
    |> Stream.with_index()
    |> Stream.filter(&(elem(&1, 0)[0] == name))
    |> Stream.drop(n - 1)
    |> Enum.at(0)
    |> case do
      {segment_data, index} ->
        List.replace_at(hl7.segments, index, do_put_in_segment(segment_data, value, path))

      nil ->
        hl7.segments
    end
  end

  defp do_put(%{0 => _} = segment_data, path, value) do
    do_put_in_segment(segment_data, value, path)
  end

  defp do_put(repetition_list, path, value) when is_list(repetition_list) do
    Enum.map(repetition_list, &do_put_in_repetition(&1, path, value))
  end

  defp do_put(repetition_data, %{field: nil, repetition: nil} = path, value) do
    do_put_in_repetition(repetition_data, value, path)
  end

  defp do_put(_repetition_data, path, _value) do
    raise ArgumentError,
          "HL7.Path to directly update repetitions should be begin with `.`, not #{inspect(path)}"
  end

  defp do_put_in_segment(segment_data, value, %{field: f} = path) do
    Map.put(segment_data, f, do_put_in_field(segment_data[f], value, path))
    |> cap_map(f)
  end

  defp do_put_in_field(field_data, value, %{repetition: "*", component: nil} = path) do
    resolve_placement_value(field_data, value, path)
  end

  defp do_put_in_field(field_data, value, %{repetition: "*"} = path) do
    1..get_max_index(field_data)
    |> Map.new(fn i ->
      {i, do_put_in_repetition(ensure_map(field_data[i], i), value, path)}
    end)
    |> Map.put(:__max_index__, field_data[:__max_index__])
  end

  defp do_put_in_field(field_data, value, %{repetition: r} = path) do
    field_map = ensure_map(field_data, r)

    Map.put(field_map, r, do_put_in_repetition(field_map[r], value, path))
    |> cap_map(r)
  end

  defp do_put_in_repetition(repetition_data, value, %{component: nil} = path) do
    resolve_placement_value(repetition_data, value, path)
  end

  defp do_put_in_repetition(repetition_data, value, %{component: c} = path) do
    repetition_map = ensure_map(repetition_data, c)

    Map.put(repetition_map, c, do_put_in_component(repetition_map[c], value, path))
    |> cap_map(c)
  end

  defp do_put_in_component(component_data, value, %{subcomponent: nil} = path) do
    resolve_placement_value(component_data, value, path)
  end

  defp do_put_in_component(subcomponent_data, value, %{subcomponent: s} = path) do
    subcomponent_map = ensure_map(subcomponent_data, s)

    Map.put(subcomponent_map, s, resolve_placement_value(subcomponent_map[s], value, path))
    |> cap_map(s)
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

  defp nil_for_empty(""), do: nil
  defp nil_for_empty(value), do: value

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
    count = Enum.count(segments)
    names = segments |> Enum.drop(1) |> Enum.take(5) |> Enum.map(&to_string(&1[0]))
    label = Enum.join(names, ", ")
    over = count - Enum.count(names)

    if over > 0 do
      "#HL7[" <> label <> ", +" <> to_string(over) <> "]"
    else
      "#HL7[" <> label <> "]"
    end
  end
end
