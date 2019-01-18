defmodule HL7.FieldGrammar do
  require Logger

  @moduledoc false

  def to_indices(schema) do
    use_repeat = String.contains?(schema, "[")
    use_segment = String.contains?(schema, "-")
    chunks = chunk_schema(schema)
    [head | tail] = chunks

    case use_segment do
      true ->
        case use_repeat do
          true ->
            [head | tail |> Enum.map(&String.to_integer/1)]

          false ->
            [head | tail |> Enum.map(&String.to_integer/1) |> List.insert_at(1, 0)]
        end

      false ->
        case use_repeat do
          true ->
            [0 | chunks |> Enum.map(&String.to_integer/1)]

          false ->
            [0 | chunks |> Enum.map(&String.to_integer/1) |> List.insert_at(1, 0)]
        end

    end
    |> Enum.take(5)
    |> Enum.with_index()
    |> Enum.map(fn {v, i} -> if (i > 2), do: v - 1, else: v end)

  end

  defp chunk_schema(schema) do
    Regex.split(~r{(\.|\-|\[|\]|\s)}, schema, include_captures: false, trim: true)
  end
end
