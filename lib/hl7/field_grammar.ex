defmodule HL7.FieldGrammar do
  require Logger

  @derive Inspect

  defstruct [:data]

  @typep segment :: String.t()
  @typep indices :: [integer, ...]
  @type t :: %__MODULE__{
          data: {segment, indices} | indices
        }

  def to_string(%__MODULE__{data: {segment, indices}}) do
    "#{segment}-" <> Enum.join(indices, ".")
  end

  def to_string(%__MODULE__{data: indices}) when is_list(indices) do
    Enum.join(indices, ".")
  end

  defimpl String.Chars do
    def to_string(grammar) do
      HL7.FieldGrammar.to_string(grammar)
    end
  end

  @deprecated "Use FieldGrammar.new/1 instead"
  def to_indices(schema) do
    new(schema)
  end

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
