defmodule Hl7.MllpStream do
  @moduledoc """
  Turns a raw steam into an MLLP stream
  """
  require Logger

  # ^K - VT (Vertical Tab) - 0x0B
  @sb "\v"
  # ^\ - FS (File Separator)
  @eb <<0x1C>>
  # ^M - CR (Carriage Return) - 0x0D
  @cr "\r"
  @ending @eb <> @cr

  def raw_to_messages(input_stream) do
    Stream.chunk_while(input_stream, "", &chunker/2, &after_chunking/1) |> Stream.concat()
  end

  defp after_sb(text) do
    chunks = text |> String.split(@sb, parts: 2)

    case chunks do
      [_chunk] -> nil
      [_sb, msg] -> msg
    end
  end

  defp to_list_and_remnant(potential_messages) do
    [remnant | reverse_msgs] = potential_messages |> Enum.reverse()

    msgs =
      reverse_msgs
      |> Enum.map(&after_sb(&1))
      |> Enum.filter(fn m -> is_binary(m) and m != "" end)
      |> Enum.reverse()

    {:cont, msgs, remnant}
  end

  defp chunker(element, acc) when is_binary(element) do
    # {:cont, chunk, acc} | {:cont, acc} | {:halt, acc})

    text = acc <> element
    potential_msg_list = String.split(text, @ending)

    case potential_msg_list do
      [not_found] -> {:cont, not_found}
      _ -> potential_msg_list |> to_list_and_remnant
    end
  end

  defp chunker(_element, _acc) do
    raise(ArgumentError, message: "all elements in an MLLP stream must be binary")
  end

  defp after_chunking(_acc) do
    {:cont, []}
  end
end
