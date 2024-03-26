defmodule HL7.HPath do
  defstruct segment: nil,
            segment_number: 1,
            field: nil,
            repetition: 1,
            component: nil,
            subcomponent: nil,
            truncate: false,
            precision: nil,
            indices: nil

  @doc ~S"""
  The `~HP` sigil encodes an HL7 path into a struct at compile-time to guarantee correctness and speed.
  It is designed to work with data returned by `HL7.Maps.new/1`.

  `~HP"OBX-5"` means the 5th field of the 1st OBX segment.
  `~HP"OBX[1]-5"` is equivalent, the number in brackets specifying which segment iteration to target.
  `~HP"OBX[2]-5"` thus means the 5th field of the 2nd OBX segment.
  `~HP"OBX[*]-5"` would find the 5th field of every OBX segment, returning a list of results.
  `~HP"OBX"` by itself refers to the 1st OBX segment in its entirety, same as `~HP"OBX[1]"`.

  As some fields contain repetitions in HL7, these can accessed in the same manner.
  `~HP"PID-11"` is equivalent to `~HP"PID-11[1]"`.
  It would return the first repetition of the 11th field in the first PID segment.
  All repetitions can be found using the wildcard: `~HP"PID-11[*]"`.

  Components and subcomponents can also be accessed with the path structures.
  `h"OBX-2.3.1"` would return the 1st subcomponent of the 3rd component of the 2nd field of the 1st OBX.

  Lastly, if a path might have additional data such that a string might be found at either
  `~HP"OBX-2"` or `~HP"OBX-2.1"` or even `~HP"OBX-2.1.1"`, there is truncation character (the bang symbol) that
  will return the first element found in the HL7 text at the target specificity. Thus, `~HP"OBX[*]-2!"`
  would find the 1st piece of data in the 2nd field of every OBX whether it is a string or nested map.

  ## Examples

      iex> import HL7.HPath
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~HP"OBX-5")
      "1.80"

      iex> import HL7.HPath
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~HP"OBX[*]-5")
      ["1.80", "79"]

      iex> import HL7.HPath
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~HP"OBX[*]-2!")
      ["N", "NM"]

      iex> import HL7.HPath
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~HP"PID-11[*].5")
      ["35209", "35200"]

      iex> import HL7.HPath
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> HL7.Maps.new()
      ...> |> HL7.Maps.find(~HP"PID-11[2].1")
      "NICKELL’S PICKLES"

  """
  defmacro sigil_HP({:<<>>, _, [term]}, _modifiers) do
    {:ok, data, _, _, _, _} = HL7.HPathParser.parse(term)

    path_map =
      %__MODULE__{}
      |> Map.merge(Map.new(data, fn {k, v} -> {k, hd(v)} end))

    path_map
    |> then(&Map.put(&1, :precision, get_precision(&1)))
    |> then(&Map.put(&1, :indices, get_indices(&1)))
    |> Macro.escape()
  end

  defp get_precision(%__MODULE__{} = path_map) do
    cond do
      path_map.subcomponent -> :subcomponent
      path_map.component -> :component
      path_map.repetition == "*" && path_map.field -> :field
      path_map.field -> :repetition
      true -> :segment
    end
  end

  defp get_indices(%__MODULE__{} = path_map) do
    [path_map.field, path_map.repetition, path_map.component, path_map.subcomponent]
  end
end
