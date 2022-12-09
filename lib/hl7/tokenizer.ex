defmodule HL7.Tokenizer do
  @carriage_return 4
  @field 3
  @repetition 2
  @component 1
  @sub_component 0

  defmacrop copy(should_copy, binary) do
    quote bind_quoted: [binary: binary, should_copy: should_copy] do
      case should_copy do
        true -> :binary.copy(binary)
        _ -> binary
      end
    end
  end

  def tokenize(<<"MSH|^~\\&#", rest::binary>> = text, copy) do
    tokenize(rest, text, 9, 0, ["^~\\&#", @field, "|", @field, "MSH"], copy)
  end

  def tokenize(<<"MSH|^~\\&", rest::binary>> = text, copy) do
    tokenize(rest, text, 8, 0, ["^~\\&", @field, "|", @field, "MSH"], copy)
  end

  def tokenize(text, _copy) do
    HL7.DynamicTokenizer.tokenize(text)
  end

  defp tokenize(<<"|", rest::binary>>, original, skip, len, acc, copy) do
    tokenize_terminator(rest, original, skip, len, acc, @field, copy)
  end

  defp tokenize(<<"~", rest::binary>>, original, skip, len, acc, copy) do
    tokenize_terminator(rest, original, skip, len, acc, @repetition, copy)
  end

  defp tokenize(<<"^", rest::binary>>, original, skip, len, acc, copy) do
    tokenize_terminator(rest, original, skip, len, acc, @component, copy)
  end

  defp tokenize(<<"&", rest::binary>>, original, skip, len, acc, copy) do
    tokenize_terminator(rest, original, skip, len, acc, @sub_component, copy)
  end

  defp tokenize(<<"\r", rest::binary>>, original, skip, len, acc, copy) do
    tokenize_terminator(rest, original, skip, len, acc, @carriage_return, copy)
  end

  defp tokenize(<<"\n", rest::binary>>, original, skip, len, acc, copy) do
    tokenize_terminator(rest, original, skip, len, acc, @carriage_return, copy)
  end

  defp tokenize(<<_char::binary-size(1), rest::binary>>, original, skip, len, acc, copy) do
    tokenize(rest, original, skip, len + 1, acc, copy)
  end

  defp tokenize("", _original, _skip, 0, acc, _copy) do
    Enum.reverse(acc)
  end

  defp tokenize("", original, skip, len, acc, copy) do
    string = copy(copy, binary_part(original, skip, len))
    Enum.reverse([string | acc])
  end

  defp tokenize_terminator(text, original, skip, 0, acc, terminator, copy) do
    tokenize(text, original, skip + 1, 0, [terminator | acc], copy)
  end

  defp tokenize_terminator(text, original, skip, len, acc, terminator, copy) do
    string = copy(copy, binary_part(original, skip, len))
    tokenize(text, original, skip + len + 1, 0, [terminator, string | acc], copy)
  end

  @compile {:inline, tokenize: 6, tokenize_terminator: 7}
end
