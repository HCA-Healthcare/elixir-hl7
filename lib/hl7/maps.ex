defmodule HL7.Maps do
  @type hl7_map_data() :: %{
          optional(non_neg_integer) => hl7_map_data() | String.t(),
          e: non_neg_integer()
        }
  @type hl7_list_data() :: String.t() | [hl7_list_data]
  @type t() :: [hl7_map_data()]

  alias HL7.HPath

  @spec new(hl7_list_data()) :: t()
  def new(segments) when is_list(segments) do
    Enum.map(segments, fn segment -> to_map(%{}, 0, segment) end)
  end

  def new(segments) when is_binary(segments) do
    new(HL7.Message.to_list(segments))
  end

  def new(%HL7.Message{} = segments) do
    new(HL7.Message.to_list(segments))
  end

  @spec label(t() | hl7_map_data(), map()) :: map()
  def label(segment_or_segments, output_mapping) do
    for {key, output_param} <- output_mapping, into: Map.new() do
      {key, do_label(segment_or_segments, output_param) |> nil_for_empty()}
    end
  end

  @doc ~S"""
  Finds data within a segment map (or list of segment maps) using an `HL7.HPath` sigil.

  Selecting data across multiple segments or repetitions with the wildcard `[*]` pattern
  will return a list of results.

  ## Examples

      iex> import HL7.HPath
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~h"OBX-5")
      "1.80"

      iex> import HL7.HPath
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~h"OBX[*]-5")
      ["1.80", "79"]

      iex> import HL7.HPath
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~h"OBX[*]-2!")
      ["N", "NM"]

      iex> import HL7.HPath
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~h"PID-11[*].5")
      ["35209", "35200"]

      iex> import HL7.HPath
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~h"PID-11[2].1")
      "NICKELL’S PICKLES"

  """

  @spec find(t() | hl7_map_data(), %HPath{}) :: hl7_list_data() | hl7_map_data() | nil
  def find(segment_list, %HPath{segment_number: "*", segment: name} = hpath)
      when is_list(segment_list) do
    segment_list
    |> Enum.filter(fn segment -> segment[0] == name end)
    |> Enum.map(fn segment -> find_in_segment(segment, hpath) end)
  end

  def find(segment_list, %HPath{segment_number: num, segment: name} = hpath)
      when is_list(segment_list) do
    segment_list
    |> Enum.filter(fn segment -> segment[0] == name end)
    |> Enum.drop(num - 1)
    |> Enum.at(0)
    |> find_in_segment(hpath)
  end

  def find(segment, %HPath{} = hpath) when is_map(segment) do
    find_in_segment(segment, hpath)
  end

  def chunk_by_segment(segment_list, segment_name) do
    do_chunk_by_segment([], [], segment_list, segment_name)
  end

  def reject_z_segments(segment_list) do
    Enum.reject(segment_list, fn segment -> String.at(segment[0], 0) == "Z" end)
  end

  @doc """
  Converts segment maps or lists of segments maps into a raw Elixir list.
  """

  @spec to_list(hl7_map_data()) :: hl7_list_data()
  def to_list(map_data) when is_list(map_data) do
    Enum.map(map_data, fn segment_map -> do_to_list(segment_map) end)
  end

  def to_list(map_data) when is_map(map_data) do
    do_to_list(map_data)
  end

  # internals

  defp to_map(value) when is_binary(value) do
    value
  end

  defp to_map(value) when is_list(value) do
    to_map(%{}, 1, value)
  end

  defp to_map(acc, index, []) do
    Map.put(acc, :e, index - 1)
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
    do_to_list([], hl7_map_data, hl7_map_data[:e])
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

  defp do_chunk_by_segment(acc, chunk_acc, [%{0 => segment_name} = segment | rest], segment_name) do
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

  defp find_in_segment(segment, %HPath{field: nil} = _hpath) do
    segment
  end

  defp find_in_segment(segment, %HPath{field: f} = hpath) do
    find_in_field(segment[f], hpath)
  end

  defp find_in_field(field, %HPath{repetition: "*", component: nil}) when is_binary(field) do
    [field]
  end

  defp find_in_field(field, %HPath{repetition: "*", component: _}) when is_binary(field) do
    []
  end

  defp find_in_field(nil, %HPath{repetition: "*"}) do
    []
  end

  defp find_in_field(field, %HPath{repetition: "*"} = hpath) when is_map(field) do
    1..field[:e] |> Enum.map(fn i -> find_in_repetition(field[i], hpath) end)
  end

  defp find_in_field(field, %HPath{repetition: 1, component: nil}) when is_binary(field) do
    field
  end

  defp find_in_field(field, %HPath{repetition: 1, component: 1}) when is_binary(field) do
    field
  end

  defp find_in_field(field, %HPath{repetition: 1, component: _}) when is_binary(field) do
    nil
  end

  defp find_in_field(field, %HPath{repetition: r} = hpath) when is_map_key(field, r) do
    find_in_repetition(field[r], hpath)
  end

  defp find_in_field(_field, _hpath) do
    nil
  end

  defp find_in_repetition(nil, _hpath) do
    nil
  end

  defp find_in_repetition(repetition, %HPath{component: 1}) when is_binary(repetition) do
    repetition
  end

  defp find_in_repetition(repetition, %HPath{component: _}) when is_binary(repetition) do
    nil
  end

  defp find_in_repetition(repetition, %HPath{truncate: true} = hpath) do
    find_in_component(repetition[1], hpath)
  end

  defp find_in_repetition(repetition, %HPath{component: nil}) do
    repetition
  end

  defp find_in_repetition(repetition, %HPath{component: c, subcomponent: nil}) do
    repetition[c]
  end

  defp find_in_repetition(repetition, %HPath{component: c, subcomponent: _} = hpath) do
    find_in_component(repetition[c], hpath)
  end

  defp find_in_component(component, %HPath{truncate: true}) when is_binary(component) do
    component
  end

  defp find_in_component(component, %HPath{truncate: true}) do
    component[1]
  end

  defp find_in_component(component, %HPath{subcomponent: 1}) when is_binary(component) do
    component
  end

  defp find_in_component(component, %HPath{subcomponent: _}) when is_binary(component) do
    nil
  end

  defp find_in_component(component, %HPath{subcomponent: nil}) do
    component
  end

  defp find_in_component(component, %HPath{subcomponent: s}) do
    component[s]
  end

  defp do_label(segment_data, %HPath{} = output_param) do
    find(segment_data, output_param)
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
end
