defmodule HL7.SplitStream do
  @moduledoc """
  Turns a raw steam into an MLLP stream
  """
  require Logger

  def raw_to_messages(input_stream, prefix, suffix) do
    chunker = get_chunker(prefix, suffix)
    Stream.chunk_while(input_stream, "", chunker, &after_chunking/1) |> Stream.concat()
  end

  defp get_after_prefix(nil) do
    fn text -> text end
  end

  defp get_after_prefix(prefix) when is_binary(prefix) do
    fn text ->
      chunks = text |> String.split(prefix, parts: 2)

      case chunks do
        [_chunk] -> nil
        [_sb, msg] -> msg
      end
    end
  end

  defp get_after_prefix(%Regex{} = prefix) do

    fn text ->
      chunks = text |> Regex.split(prefix, parts: 2)

      case chunks do
        [_chunk] -> nil
        [_sb, msg] -> msg
      end
    end
  end

  defp get_split_on_suffix(suffix) when is_binary(suffix) do
    fn text -> String.split(text, suffix) end
  end


  defp get_split_on_suffix(%Regex{} = suffix) do
    fn text -> Regex.split(suffix, text, trim: true) end
  end

  defp get_chunker(prefix, suffix) do
    to_list_and_remnant = get_to_list_and_remnant(prefix)
    split_on_suffix = get_split_on_suffix(suffix)

    fn
      element, acc when is_binary(element) ->
        # {:cont, chunk, acc} | {:cont, acc} | {:halt, acc})

        text = acc <> element
        potential_msg_list = split_on_suffix.(text)

        case potential_msg_list do
          [not_found] -> {:cont, not_found}
          _ -> to_list_and_remnant.(potential_msg_list)
        end

      _element, _acc ->
        raise(ArgumentError, message: "all elements in an HL7 stream must be binary")
    end
  end

  defp get_to_list_and_remnant(prefix) do
    after_prefix = get_after_prefix(prefix)

    fn potential_messages ->
      [remnant | reverse_msgs] = potential_messages |> Enum.reverse()

      msgs =
        reverse_msgs
        |> Enum.map(fn m -> after_prefix.(m) end)
        |> Enum.filter(fn m -> is_binary(m) and m != "" end)
        |> Enum.reverse()

      {:cont, msgs, remnant}
    end
  end

  defp after_chunking(_acc) do
    {:cont, []}
  end
end
