defmodule HL7.Path do
  defstruct segment: nil,
            segment_number: nil,
            field: nil,
            repetition: nil,
            component: nil,
            subcomponent: nil,
            truncate: false,
            data: nil,
            path: nil

  @type level() :: :segment | :field | :repetition | :component | :subcomponent
  @type t() :: %__MODULE__{}

  @doc ~S"""
  Generates an `~p` sigil data structure at runtime.

  ## Examples

      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.new!()
      ...> |> HL7.get(HL7.Path.new("OBX-5"))
      "1.80"
  """

  def new(path) do
    import HL7.PathParser
    {:ok, data, _, _, _, _} = parse(path)

    path_map =
      %__MODULE__{}
      |> Map.merge(Map.new(data, fn {k, v} -> {k, List.first(v)} end))
      |> apply_default_repetition()
      |> apply_default_segment_number()

    %__MODULE__{
      path_map
      | path: path,
        data: get_data(path, path_map)
    }
  end

  defp apply_default_segment_number(%__MODULE__{segment: nil} = path_map) do
    path_map
  end

  defp apply_default_segment_number(%__MODULE__{segment_number: nil} = path_map) do
    Map.put(path_map, :segment_number, 1)
  end

  defp apply_default_segment_number(%__MODULE__{} = path_map) do
    path_map
  end

  defp apply_default_repetition(%__MODULE__{field: nil, repetition: r} = path_map) do
    if is_nil(r) do
      path_map
    else
      raise ArgumentError,
            "HL7.Path cannot contain a repetition without a field or segment number with a segment"
    end
  end

  defp apply_default_repetition(%__MODULE__{repetition: nil} = path_map) do
    Map.put(path_map, :repetition, 1)
  end

  defp apply_default_repetition(%__MODULE__{} = path_map) do
    path_map
  end

  # temporary backwards compatibility data for `HL7.Query` paths, to be deprecated in the future
  defp get_data(path, %__MODULE__{} = path_map) do
    repetition =
      cond do
        String.contains?(path, "[") and is_integer(path_map.repetition) -> path_map.repetition - 1
        path_map.component || path_map.subcomponent -> 0
        true -> nil
      end

    m = %__MODULE__{path_map | repetition: repetition}

    indices =
      cond do
        m.subcomponent -> [m.field, m.repetition, m.component - 1, m.subcomponent - 1]
        m.component -> [m.field, m.repetition, m.component - 1]
        m.repetition -> [m.field, m.repetition]
        m.field -> [m.field]
        true -> []
      end

    if m.segment, do: {m.segment, indices}, else: indices
  end
end

defimpl Inspect, for: HL7.Path do
  def inspect(%HL7.Path{path: path}, _opts) do
    "~p[" <> path <> "]"
  end
end
