defmodule HL7.Path do
  @derive Inspect
  defstruct segment: nil,
            segment_number: 1,
            field: nil,
            repetition: 1,
            component: nil,
            subcomponent: nil,
            truncate: false,
            indices: nil,
            data: nil

  @type t() :: %__MODULE__{}

  @doc ~S"""
  The `~p` sigil encodes an HL7 path into a struct at compile-time to guarantee correctness and speed.
  It is designed to work with data returned by `HL7.parse!/1`.

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

      iex> import HL7.Path
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.parse!()
      ...> |> HL7.get(~p"OBX-5")
      "1.80"

      iex> import HL7.Path
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.parse!()
      ...> |> HL7.get(~p"OBX[*]-5")
      ["1.80", "79"]

      iex> import HL7.Path
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.parse!()
      ...> |> HL7.get(~p"OBX[*]-2!")
      ["N", "NM"]

      iex> import HL7.Path
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.parse!()
      ...> |> HL7.get(~p"PID-11[*].5")
      ["35209", "35200"]

      iex> import HL7.Path
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.parse!()
      ...> |> HL7.get(~p"PID-11[2].1")
      "NICKELL’S PICKLES"

  """
  defmacro sigil_p({:<<>>, _, [path]}, _modifiers) do
    path
    |> new()
    |> Macro.escape()
  end

  @doc ~S"""
  Generates an `~p` sigil data structure at runtime.

  ## Examples

      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.parse!()
      ...> |> HL7.get(HL7.Path.new("OBX-5"))
      "1.80"
  """

  def new(path) do
    import HL7.PathParser
    {:ok, data, _, _, _, _} = parse(path)

    path_map =
      %__MODULE__{}
      |> Map.merge(Map.new(data, fn {k, v} -> {k, hd(v)} end))

    %__MODULE__{path_map | indices: get_indices(path_map), data: get_data(path, path_map)}
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
