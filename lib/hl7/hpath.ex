defmodule HL7.HPath do
  defstruct segment: nil,
            segment_number: 1,
            field: nil,
            repetition: 1,
            component: nil,
            subcomponent: nil,
            truncate: false

  defmacro sigil_h({:<<>>, _, [term]}, _modifiers) do
    {:ok, data, _, _, _, _} = HL7.HPathParser.parse(term)

    %__MODULE__{}
    |> Map.merge(Map.new(data, fn {k, v} -> {k, hd(v)} end))
    |> Macro.escape()
  end
end
