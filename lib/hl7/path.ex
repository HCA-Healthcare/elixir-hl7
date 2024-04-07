defmodule HL7.Path do
  defstruct segment: nil,
            segment_number: 1,
            field: nil,
            repetition: 1,
            component: nil,
            subcomponent: nil,
            truncate: false,
            indices: nil,
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
      |> Map.merge(Map.new(data, fn {k, v} -> {k, hd(v)} end))

    %__MODULE__{
      path_map
      | path: path,
        indices: get_indices(path_map),
        data: get_data(path, path_map)
    }
  end

  defp get_indices(%__MODULE__{} = path_map) do
    [path_map.field, path_map.repetition, path_map.component, path_map.subcomponent]
  end

  # temporary backwards compatibility data for `HL7.Query` paths, to be deprecated in the future
  defp get_data(path, %__MODULE__{} = path_map) do
    repetition =
      cond do
        String.contains?(path, "[") and path_map.repetition != "*" -> path_map.repetition - 1
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
