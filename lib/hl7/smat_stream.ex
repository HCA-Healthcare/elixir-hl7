defmodule HL7.SMATStream do
  @moduledoc false
  require Logger

  @spec raw_to_messages(Enumerable.t()) :: Enumerable.t()
  def raw_to_messages(input_stream) do
    Stream.chunk_while(input_stream, "", &chunker/2, &after_chunking/1) |> Stream.concat()
  end

  @spec to_list_and_remnant(list()) :: {:cont, list(), String.t()}
  defp to_list_and_remnant(potential_messages) do
    [remnant | reverse_msgs] = potential_messages |> Enum.reverse()

    msgs =
      reverse_msgs
      |> Enum.filter(fn m -> is_binary(m) and m != "" end)
      |> Enum.reverse()

    {:cont, msgs, remnant}
  end

  @spec chunker(String.t(), String.t()) :: {:cont, String.t()} | {:cont, list(), String.t()}
  defp chunker(element, acc) when is_binary(element) do
    # {:cont, chunk, acc} | {:cont, acc} | {:halt, acc})

    text = acc <> element

    potential_msg_list =
      Regex.split(
        ~r/\s\S*\{CONNID \d+\} \{IPVERSION \d\} \{CLIENTIP \S+\} {CLIENTPORT \S+}/,
        text,
        trim: true
      )

    case potential_msg_list do
      [not_found] -> {:cont, not_found}
      _ -> potential_msg_list |> to_list_and_remnant
    end
  end

  defp chunker(_element, _acc) do
    raise(ArgumentError, message: "all elements in an SMAT stream must be binary")
  end

  @spec after_chunking(any()) :: {:cont, list()}
  defp after_chunking(_acc) do
    {:cont, []}
  end
end
