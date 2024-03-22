defmodule HL7.HPath do
  defstruct segment: nil,
            segment_number: 1,
            field: nil,
            repetition: 1,
            component: nil,
            subcomponent: nil,
            truncate: false

  @doc ~S"""
  The `~h` sigil encodes an HL7 path into a struct at compile-time to guarantee correctness and speed.
  It is designed to work with data returned by `HL7.Maps.new/1`.

  `~h"OBX-5"` means the 5th field of the 1st OBX segment.
  `~h"OBX[1]-5"` is equivalent, the number in brackets specifying which segment iteration to target.
  `~h"OBX[2]-5"` thus means the 5th field of the 2nd OBX segment.
  `~h"OBX[*]-5"` would find the 5th field of every OBX segment, returning a list of results.
  `~h"OBX"` by itself refers to the 1st OBX segment in its entirety, same as `~h"OBX[1]"`.

  As some fields contain repetitions in HL7, these can accessed in the same manner.
  `~h"PID-11"` is equivalent to `~h"PID-11[1]"`.
  It would return the first repetition of the 11th field in the first PID segment.
  All repetitions can be found using the wildcard: `~h"PID-11[*]"`.

  Components and subcomponents can also be accessed with the path structures.
  `h"OBX-2.3.1"` would return the 1st subcomponent of the 3rd component of the 2nd field of the 1st OBX.

  Lastly, if a path might have additional data such that a string might be found at either
  `~h"OBX-2"` or `~h"OBX-2.1"` or even `~h"OBX-2.1.1"`, there is truncation character (the bang symbol) that
  will return the first element found in the HL7 text at the target specificity. Thus, `~h"OBX[*]-2!"`
  would find the 1st piece of data in the 2nd field of every OBX whether it is a string or nested map.

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
  defmacro sigil_h({:<<>>, _, [term]}, _modifiers) do
    {:ok, data, _, _, _, _} = HL7.HPathParser.parse(term)

    %__MODULE__{}
    |> Map.merge(Map.new(data, fn {k, v} -> {k, hd(v)} end))
    |> Macro.escape()
  end
end
