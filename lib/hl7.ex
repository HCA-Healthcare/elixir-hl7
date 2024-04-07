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

  The segment maps using integer keys corresponding to the data's HL7 positions (starting at 1).
  Segment names are stored at position 0. To save on space and to make a cleaner presentation, empty values
  are not included in the output. Instead, each map contains an `:__max_index__` field that notes the highest index
  present in the source data.
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
  Finds data within a segment map (or list of segment maps) using an `HL7.Path` sigil.

  Selecting data across multiple segments or repetitions with the wildcard `[*]` pattern
  will return a list of results.

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

  """

  @spec get(parsed_hl7(), %Path{}) ::
          hl7_map_data() | String.t() | nil
  def get(%HL7{segments: segment_list}, path) do
    HL7.get(segment_list, path)
  end

  def get(segment_list, %Path{segment_number: "*", segment: name} = path)
      when is_list(segment_list) do
    segment_list
    |> Enum.filter(&(&1[0] == name))
    |> Enum.map(&get_in_segment(&1, path))
    |> Enum.map(&uncap_nested_output_map/1)
  end

  def get(segment_list, %Path{segment_number: num, segment: name} = path)
      when is_list(segment_list) do
    segment_list
    |> Stream.filter(&(&1[0] == name))
    |> Stream.drop(num - 1)
    |> Enum.at(0)
    |> get_in_segment(path)
    |> uncap_nested_output_map()
  end

  def get(segment, %Path{} = path) when is_map(segment) do
    get_in_segment(segment, path) |> uncap_nested_output_map()
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

  defp truncate(segment_data) when is_binary(segment_data) or is_nil(segment_data) do
    segment_data
  end

  defp truncate(segment_data) when is_map(segment_data) do
    get_value_at_index(segment_data, 1)
    |> truncate()
  end

  defp resolve_placement_value(_field_data = nil, {default, _fun}) do
    default |> cap_nested_input_map()
  end

  defp resolve_placement_value(field_data, {_default, fun}) do
    fun.(field_data) |> cap_nested_input_map()
  end

  defp resolve_placement_value(_field_data = nil, {_fun}) do
    raise KeyError, message: "HL7.Path data not found"
  end

  defp resolve_placement_value(field_data, {fun}) do
    fun.(field_data) |> cap_nested_input_map()
  end

  defp resolve_placement_value(_field_data, value) do
    value |> cap_nested_input_map()
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
    Enum.map(repetition_list, &do_put(&1, path, value))
  end

  defp do_put(repetition_data, %{field: nil, repetition: nil} = path, value) do
    do_put_in_repetition(repetition_data, value, path)
  end

  defp do_put(repetition_data, path, value) do
    raise ArgumentError, "HL7.Path to directly update repetitions should be begin with `.`, not #{inspect(path)}"
  end

  defp do_put_in_segment(segment_data, value, %{field: f} = path) do
    Map.put(segment_data, f, do_put_in_field(segment_data[f], value, path))
    |> cap_map(f)
  end

  defp do_put_in_field(field_data, value, %{repetition: "*", component: nil}) do
    resolve_placement_value(field_data, value)
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

  defp do_put_in_repetition(repetition_data, value, %{component: nil}) do
    resolve_placement_value(repetition_data, value)
  end

  defp do_put_in_repetition(repetition_data, value, %{component: c} = path) do
    repetition_map = ensure_map(repetition_data, c)

    Map.put(repetition_map, c, do_put_in_component(repetition_map[c], value, path))
    |> cap_map(c)
  end

  defp do_put_in_component(component_data, value, %{subcomponent: nil}) do
    resolve_placement_value(component_data, value)
  end

  defp do_put_in_component(subcomponent_data, value, %{subcomponent: s}) do
    subcomponent_map = ensure_map(subcomponent_data, s)

    Map.put(subcomponent_map, s, resolve_placement_value(subcomponent_map[s], value))
    |> cap_map(s)
  end

  defp get_in_segment(segment, path) do
    get_in_segment(segment, path, path.indices)
  end

  defp get_in_segment(_segment_data = nil, _path, _indices) do
    nil
  end

  defp get_in_segment(segment_data, %Path{truncate: true}, []) do
    truncate(segment_data)
  end

  defp get_in_segment(segment_data, %Path{truncate: false}, []) do
    segment_data
  end

  defp get_in_segment(segment_data, _path, ["*" | remaining_indices])
       when is_binary(segment_data) do
    if Enum.all?(remaining_indices, fn i -> i in [1, nil] end), do: [segment_data], else: [nil]
  end

  defp get_in_segment(segment_data, path, [1 | remaining_indices])
       when is_binary(segment_data) do
    get_in_segment(segment_data, path, remaining_indices)
  end

  defp get_in_segment(segment_data, _path, [nil | _remaining_indices])
       when is_binary(segment_data) do
    segment_data
  end

  defp get_in_segment(segment_data, _path, [_ | _remaining_indices])
       when is_binary(segment_data) do
    nil
  end

  defp get_in_segment(segment_data, path, ["*" | remaining_indices]) do
    1..get_max_index(segment_data)
    |> Enum.map(fn i ->
      get_in_segment(get_value_at_index(segment_data, i), path, remaining_indices)
    end)
  end

  defp get_in_segment(segment_data, path, [nil | _remaining_indices]) do
    get_in_segment(segment_data, path, [])
  end

  defp get_in_segment(segment_data, path, [i | remaining_indices]) do
    get_in_segment(get_value_at_index(segment_data, i), path, remaining_indices)
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

  def demo do
    """
    MSH|^~\\&||MMSAV|||20240208152225|EDIREGO|ADT^A08^EPIC_ADT|67958|T|2.3|||||||||||
    EVN|A08|20240208152225||UPDATE_REPLAY_ADMIT|EDIREGO^INTERFACE^REGISTRATION^OUT^^^^^SA^^^^^||
    PID|1||10001948^^^EPICSA^MRN||TELETRACKING^ED||19730315|F||W|3748 MAIN ST^^ATLANTA^GA^30303^USA^P^^FULTON|FULTON|(555)777-5554^P^H^^^555^7775554~^NET^Internet^none@none.com~(555)777-5554^P^M^^^555^7775554||ENGLISH|M||900010168|777-77-7777|||NOT HISPANIC||||||||N||
    ZPD||Email~MYCH~Mail|||||N|||||||||||||||||F|||||||||
    PD1|||MEMORIAL HEALTH^^50001001|1627363736^FAMILY MEDICINE^PHYSICIAN^^^^^^NPI^^^^NPI||||||||||||||
    ROL|1|UP|GENERAL|ROL41^FAMILY MEDICINE^PHYSICIAN^^^^^^THREEFOUR^^^^NPI~OTHER ROL-4.1^FAMILY MEDICINE^PHYSICIAN^^^^^^OTHER ROL-4.9^^^^NPI|20230315|20240315|||GENERAL||123 ANYWHERE STREET^^MADISON^WI^53711^^^^DANE|(555)555-5555^^W^^^555^5555555~(912)352-4728^^FAX^^^912^3524728    CON|1|ADLW|||||||||Not Recv||||||||||||||
    ROL|2|DOWN|ANOTHER ROLE|abc1234^FAMILY MEDICINE^PHYSICIAN^^^^^^THREEFOUR^^^^NPI~OTHER ROL-4.1^FAMILY MEDICINE^PHYSICIAN^^^^^^OTHER ROL-4.9^^^^NPI|20230316|20240318|||GENERAL||123 ANYWHERE STREET^^MADISON^WI^53711^^^^DANE|(555)555-5555^^W^^^555^5555555~(912)352-4728^^FAX^^^912^3524728    CON|1|ADLW|||||||||Not Recv||||||||||||||
    NK1|1|ED^SPOUSE^^|01||(555)777-5544^^H^^^555^7775544^^|||||||||||||||||||||||||||||||
    PV1|1|E|MSAVED^A37^A37A^MMSAV^^^^^^^|E||||||ED|||||||||4000015920|99|||||||||||||||||||||ADM|||20240208152200||||||4000015920||||
    PV2||PR||||||||||||||||||||N||||||||||N||||||WI|||||||||||
    ZPV|||||||||||||20240208152200||||||||||||||||||||||||||(912)350-8113^^^^^912^3508113|
    OBX|1|TX|ACCSTAT1^ADT: PATIENT STATUS|1|Adm|||||||||20240208||||||||||||||||||
    OBX|2|TX|ACCSTAT1^HOSPITAL - ADMIT CONFIRMATION STATUS|1|Conf|||||||||20240208||||||||||||||||||
    DG1|1|I10|Y93.C1^Activity, computer keyboarding^I10|Activity, computer keyboarding|20230315122320|^19450;EPT||||||||||||||||||||
    DG1|2|I10|N17.9^Acute kidney failure, unspecified^I10|Acute kidney failure, unspecified|20231121150913|^19450;EPT||||||||||||||||||||
    DG1|3|I10|N18.5^Chronic kidney disease, stage 5^I10|Chronic kidney disease, stage 5|20231121150913|^19450;EPT||||||||||||||||||||
    DG1|4|I10|Y93.J1^Activity, piano playing^I10|Activity, piano playing|20231115173003|^19450;EPT||||||||||||||||||||
    DG1|5|I10|W55.52XD^Struck by raccoon, subsequent encounter^I10|Struck by raccoon, subsequent encounter|20231121151405|^19450;EPT||||||||||||||||||||
    GT1|1|500001330|TELETRACKING^ED^^^^^L||3748 MAIN ST^^ATLANTA^GA^30303^USA^^^FULTON|(555)777-5554^P^H^^^555^7775554~(555)777-5554^P^M^^^555^7775554~^NET^Internet^none@none.com||19730315|F|P/F|SLF|777-77-7777||||||||Full|||||||||||||||||||||||||||||
    ZG1||||
    """
    |> String.replace("\n", "\r")
    |> HL7.Message.new()
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
