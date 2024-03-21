defmodule HL7.MapData do
  @type hl7_map_data() :: %{optional(non_neg_integer) => t() | String.t(), e: non_neg_integer()}
  @type hl7_list_data() :: String.t() | [hl7_list_data]
  @type t() :: [hl7_map_data()]

  alias HL7.HPath

  @spec new([hl7_list_data]) :: t()
  def new(segment_list) when is_list(segment_list) do
    Enum.map(segment_list, fn segment -> to_map(%{}, 0, segment) end)
  end

  # map data to a map full of hpaths/funs
  def correlate(segment_list, result_map) when is_list(segment_list) do
    result_map
  end

  # find data based on hpath
  def find(segment_list, %HPath{segment_number: "*", segment: name} = hpath) when is_list(segment_list) do
    segment_list
    |> Enum.filter(fn segment -> segment[0] == name end)
    |> Enum.map(fn segment -> find_in_segment(segment, hpath) end)
  end

  def find(segment_list, %HPath{segment_number: num, segment: name} = hpath) when is_list(segment_list) do
    segment_list
    |> Enum.filter(fn segment -> segment[0] == name end)
    |> Enum.drop(num - 1)
    |> Enum.at(0)
    |> find_in_segment(hpath)
  end

  def find_in_segment(segment, %HPath{field: nil} = _hpath) do
    segment
  end

  def find_in_segment(segment, %HPath{field: f} = hpath) do
    find_in_field(segment[f], hpath)
  end

  def find_in_field(field, %HPath{repetition: "*", component: nil} = hpath) when is_binary(field) do
    [field]
  end

  def find_in_field(field, %HPath{repetition: "*", component: _} = hpath) when is_binary(field) do
    []
  end

  def find_in_field(nil, %HPath{repetition: "*"} = hpath) do
    []
  end

  def find_in_field(field, %HPath{repetition: "*"} = hpath) when is_map(field) do
    1..(field[:e]) |> Enum.map(fn i -> find_in_repetition(field[i], hpath) end)
  end

  def find_in_field(field, %HPath{repetition: 1, component: nil} = hpath) when is_binary(field) do
    field
  end

  def find_in_field(field, %HPath{repetition: 1, component: 1} = hpath) when is_binary(field) do
    field
  end

  def find_in_field(field, %HPath{repetition: 1, component: _} = hpath) when is_binary(field) do
    nil
  end

  def find_in_field(field, %HPath{repetition: r} = hpath) when is_map_key(field, r) do
    find_in_repetition(field[r], hpath)
  end

  def find_in_field(_field, _hpath)  do
    nil
  end

  def find_in_repetition(nil, _hpath) do
    nil
  end

  def find_in_repetition(repetition, %HPath{component: nil} = hpath) do
    repetition
  end

  def find_in_repetition(repetition, %HPath{component: c, subcomponent: nil} = hpath) do
    Map.get(repetition, c)
  end

  def find_in_repetition(repetition, %HPath{component: c, subcomponent: s} = hpath) do
    case Map.get(repetition, c) do
      nil -> nil
      comp_data -> comp_data[s]
    end
  end

  # split map data up by leading segment name
  def chunk_within(segment_list, segment_name) do

  end

  @spec to_list(t()) :: [hl7_list_data()]
  def to_list(map_data) when is_list(map_data) do
    Enum.map(map_data, fn segment_map -> do_to_list(segment_map) end)
  end

  def to_list(map_data) when is_map(map_data) do
    do_to_list(map_data)
  end

  def do_to_list(hl7_map_data) when is_binary(hl7_map_data) do
    hl7_map_data
  end

  def do_to_list(hl7_map_data) do
    do_to_list([], hl7_map_data, hl7_map_data[:e])
  end

  defp do_to_list(acc, hl7_map_data, index) do
    case hl7_map_data[index] do
      nil -> acc
      chunk -> do_to_list([do_to_list(chunk) | acc], hl7_map_data, index - 1)
    end
  end

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
    acc
    |> Map.put(index, to_map(h))
    |> to_map(index + 1, t)
  end
end
