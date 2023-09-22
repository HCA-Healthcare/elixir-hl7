defmodule HL7.Map do
  @type hl7_map :: %{optional(non_neg_integer) => hl7_map | String.t()}
  @typep hl7_chunk :: String.t() | [hl7_chunk]

  @spec new(hl7_list :: [hl7_chunk]) :: hl7_map
  def new(hl7_list) when is_list(hl7_list) do
    to_map(%{}, 0, hl7_list)
  end

  defp to_map(value) when is_binary(value) do
    value
  end

  defp to_map(value) when is_list(value) do
    to_map(%{}, 0, value)
  end

  defp to_map(acc, _index, []) do
    acc
  end

  defp to_map(acc, index, [h | t]) do
    acc
    |> Map.put(index, to_map(h))
    |> to_map(index + 1, t)
  end
end
