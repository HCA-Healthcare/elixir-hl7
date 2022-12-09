defmodule HL7.Tokenizer do
  @carriage_return 4
  @field 3
  @repetition 2
  @component 1
  @sub_component 0

  def tokenize(<<"MSH|^~\\&#", rest::binary>> = text, copy) do
    tokenize(rest, text, 9, 0, ["^~\\&#", @field, "|", @field, "MSH"], get_copy_fun(copy))
  end

  def tokenize(<<"MSH|^~\\&", rest::binary>> = text, copy) do
    tokenize(rest, text, 8, 0, ["^~\\&", @field, "|", @field, "MSH"], get_copy_fun(copy))
  end

  def tokenize(text, _copy) do
    HL7.DynamicTokenizer.tokenize(text)
  end

  defp tokenize(<<"|", rest::binary>>, original, skip, len, acc, copy_fun) do
    tokenize_terminator(rest, original, skip, len, acc, @field, copy_fun)
  end

  defp tokenize(<<"~", rest::binary>>, original, skip, len, acc, copy_fun) do
    tokenize_terminator(rest, original, skip, len, acc, @repetition, copy_fun)
  end

  defp tokenize(<<"^", rest::binary>>, original, skip, len, acc, copy_fun) do
    tokenize_terminator(rest, original, skip, len, acc, @component, copy_fun)
  end

  defp tokenize(<<"&", rest::binary>>, original, skip, len, acc, copy_fun) do
    tokenize_terminator(rest, original, skip, len, acc, @sub_component, copy_fun)
  end

  defp tokenize(<<"\r", rest::binary>>, original, skip, len, acc, copy_fun) do
    tokenize_terminator(rest, original, skip, len, acc, @carriage_return, copy_fun)
  end

  defp tokenize(<<"\n", rest::binary>>, original, skip, len, acc, copy_fun) do
    tokenize_terminator(rest, original, skip, len, acc, @carriage_return, copy_fun)
  end

  defp tokenize(<<_char::binary-size(1), rest::binary>>, original, skip, len, acc, copy_fun) do
    tokenize(rest, original, skip, len + 1, acc, copy_fun)
  end

  defp tokenize("", _original, _skip, 0, acc, _copy_fun) do
    Enum.reverse(acc)
  end

  defp tokenize("", original, skip, len, acc, copy_fun) do
    string = copy_fun.(binary_part(original, skip, len))
    Enum.reverse([string | acc])
  end

  defp tokenize_terminator(text, original, skip, 0, acc, terminator, copy_fun) do
    tokenize(text, original, skip + 1, 0, [terminator | acc], copy_fun)
  end

  defp tokenize_terminator(text, original, skip, len, acc, terminator, copy_fun) do
    string = copy_fun.(binary_part(original, skip, len))
    tokenize(text, original, skip + len + 1, 0, [terminator, string | acc], copy_fun)
  end

  defp get_copy_fun(true), do: &:binary.copy/1
  defp get_copy_fun(false), do: &(&1)

  @compile {:inline, tokenize: 6, tokenize_terminator: 7}
end
