defmodule HL7.Path do
  @derive Inspect

  defstruct [:data]

  @typep segment :: String.t()
  @typep indices :: [integer, ...]
  @type t :: %__MODULE__{
          data: {segment, indices} | indices
        }

  @doc """
  Builds an HL7.Path

  Field paths are used in `HL7.Query` functions to find specific fields in an `HL7.Message`.
  """
  @doc since: "0.8.0"
  @spec new(String.t()) :: t()
  def new(schema) when is_binary(schema) do
    use_repeat = String.contains?(schema, "[")
    use_segment = String.contains?(schema, "-")
    use_component = String.contains?(schema, ".")
    chunks = chunk_schema(schema)
    [head | tail] = chunks

    data =
      case use_segment do
        true ->
          [<<segment::binary-size(3)>> | indices] =
            case use_component && !use_repeat do
              false ->
                [head | tail |> Enum.map(&String.to_integer/1)]

              true ->
                [head | tail |> Enum.map(&String.to_integer/1) |> List.insert_at(1, 1)]
            end
            |> Enum.take(5)
            |> Enum.with_index()
            |> Enum.map(fn {v, i} -> if i > 1, do: v - 1, else: v end)

          {segment, indices}

        false ->
          case use_component && !use_repeat do
            false ->
              chunks |> Enum.map(&String.to_integer/1)

            true ->
              chunks |> Enum.map(&String.to_integer/1) |> List.insert_at(1, 1)
          end
          |> Enum.take(4)
          |> Enum.with_index()
          |> Enum.map(fn {v, i} -> if i > 0, do: v - 1, else: v end)
      end

    %__MODULE__{data: data}
  end

  @spec chunk_schema(String.t()) :: [String.t()]
  defp chunk_schema(schema) do
    Regex.split(~r{(\.|\-|\[|\]|\s)}, schema, include_captures: false, trim: true)
  end
end
