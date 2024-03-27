defmodule HL7.Maps do
  @type hl7_map_data() :: %{
          optional(non_neg_integer) => hl7_map_data() | String.t(),
          e: non_neg_integer()
        }
  @type hl7_list_data() :: String.t() | [hl7_list_data]
  @type segment_map() :: %{
          0 => String.t(),
          optional(pos_integer) => hl7_map_data() | String.t(),
          e: non_neg_integer()
        }
  @type t() :: [segment_map()]

  alias HL7.Path

  @doc ~S"""
  Creates a list of segments as maps from HL7 data (accepting text, lists or the `HL7.Message` struct).

  The maps using integer keys corresponding to the data's HL7 positions (starting at 1).
  Segment names are stored at position 0. To save on space and to make a cleaner presentation, empty values
  are not included in the output. Instead, each map contains an `:e` field that notes the highest index
  present in the source data.
  """
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

  @doc ~S"""
  Labels source data (a segment map or list of segment maps) by using `HL7.Path` sigils in a labeled
  output template.

  One-arity functions placed as output template values will be called with the source data.

  ## Examples

      iex> import HL7.Path
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.label(%{mrn: ~p"PID-3!", name: ~p"PID-5.2"})
      %{mrn: "56782445", name: "BARRY"}

  """
  @spec label(t() | segment_map(), map()) :: map()
  def label(segment_or_segments, template_map) do
    for {key, output_param} <- template_map, into: Map.new() do
      {key, do_label(segment_or_segments, output_param) |> nil_for_empty()}
    end
  end

  @doc ~S"""
  Finds data within a segment map (or list of segment maps) using an `HL7.Path` sigil.

  Selecting data across multiple segments or repetitions with the wildcard `[*]` pattern
  will return a list of results.

  ## Examples

      iex> import HL7.Path
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~p"OBX-5")
      "1.80"

      iex> import HL7.Path
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~p"OBX[*]-5")
      ["1.80", "79"]

      iex> import HL7.Path
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~p"OBX[*]-2!")
      ["N", "NM"]

      iex> import HL7.Path
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~p"PID-11[*].5")
      ["35209", "35200"]

      iex> import HL7.Path
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~p"PID-11[2].1")
      "NICKELL’S PICKLES"

  """

  @spec find(t() | segment_map(), %Path{}) :: hl7_map_data() | String.t() | nil
  def find(segment_list, %Path{segment_number: "*", segment: name} = hpath)
      when is_list(segment_list) do
    segment_list
    |> Enum.filter(fn segment -> segment[0] == name end)
    |> Enum.map(fn segment -> find_in_segment(segment, hpath) end)
  end

  def find(segment_list, %Path{segment_number: num, segment: name} = hpath)
      when is_list(segment_list) do
    segment_list
    |> Stream.filter(fn segment -> segment[0] == name end)
    |> Stream.drop(num - 1)
    |> Enum.at(0)
    |> find_in_segment(hpath)
  end

  def find(segment, %Path{} = hpath) when is_map(segment) do
    find_in_segment(segment, hpath)
  end

  @doc """
  Creates a list of lists in which the specified `segment_name` is used to find the first segment map
  of each list. This function helps to do things like grouping `OBX` segments with their parent `OBR` segment.
  """
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
  Converts a segment map (or lists of segments maps) into a raw Elixir list.
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

  defp get_index_value(segment_data, 1) when is_binary(segment_data) do
    segment_data
  end

  defp get_index_value(segment_data, nil) when is_binary(segment_data) do
    segment_data
  end

  defp get_index_value(segment_data, _) when is_binary(segment_data) do
    nil
  end

  defp get_index_value(%{e: e} = _segment_data, i) when i > e do
    nil
  end

  defp get_index_value(segment_data, i) do
    Map.get(segment_data, i, "")
  end

  defp truncate(segment_data) when is_binary(segment_data) or is_nil(segment_data) do
    segment_data
  end

  defp truncate(segment_data) when is_map(segment_data) do
    get_index_value(segment_data, 1)
    |> truncate()
  end

  defp find_in_segment(segment, hpath) do
    find_in_segment(segment, hpath, hpath.indices)
  end

  defp find_in_segment(segment_data, %Path{truncate: true}, []) do
    truncate(segment_data)
  end

  defp find_in_segment(segment_data, %Path{truncate: false}, []) do
    segment_data
  end

  defp find_in_segment(segment_data, _hpath, ["*"]) when is_binary(segment_data) do
    [segment_data]
  end

  defp find_in_segment(segment_data, _hpath, ["*" | remaining_indices])
       when is_binary(segment_data) do
    if Enum.all?(remaining_indices, fn i -> i in [1, nil] end), do: [segment_data], else: [nil]
  end

  defp find_in_segment(segment_data, hpath, [1 | remaining_indices])
       when is_binary(segment_data) do
    find_in_segment(segment_data, hpath, remaining_indices)
  end

  defp find_in_segment(segment_data, _hpath, [nil | _remaining_indices])
       when is_binary(segment_data) do
    segment_data
  end

  defp find_in_segment(segment_data, _hpath, [_ | _remaining_indices])
       when is_binary(segment_data) do
    nil
  end

  defp find_in_segment(segment_data, hpath, ["*" | remaining_indices]) do
    1..segment_data[:e]
    |> Enum.map(fn i ->
      find_in_segment(get_index_value(segment_data, i), hpath, remaining_indices)
    end)
  end

  defp find_in_segment(segment_data, hpath, [nil | _remaining_indices]) do
    find_in_segment(segment_data, hpath, [])
  end

  defp find_in_segment(segment_data, hpath, [i | remaining_indices]) do
    find_in_segment(get_index_value(segment_data, i), hpath, remaining_indices)
  end

  defp do_label(segment_data, %Path{} = output_param) do
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
