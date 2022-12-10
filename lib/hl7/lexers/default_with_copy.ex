defmodule HL7.Lexers.DefaultWithCopy do
  @carriage_return 4
  @field 3
  @repetition 2
  @component 1
  @sub_component 0

  def tokenize(<<"MSH|^~\\&#", rest::binary>> = text) do
    tokenize(rest, text, 9, 0, ["^~\\&#", @field, "|", @field, "MSH"])
  end

  def tokenize(<<"MSH|^~\\&", rest::binary>> = text) do
    tokenize(rest, text, 8, 0, ["^~\\&", @field, "|", @field, "MSH"])
  end

  def tokenize(text) do
    HL7.Lexers.DynamicWithCopy.tokenize(text)
  end

  defp tokenize(<<"|", rest::binary>>, original, skip, len, acc) do
    tokenize_terminator(rest, original, skip, len, acc, @field)
  end

  defp tokenize(<<"~", rest::binary>>, original, skip, len, acc) do
    tokenize_terminator(rest, original, skip, len, acc, @repetition)
  end

  defp tokenize(<<"^", rest::binary>>, original, skip, len, acc) do
    tokenize_terminator(rest, original, skip, len, acc, @component)
  end

  defp tokenize(<<"&", rest::binary>>, original, skip, len, acc) do
    tokenize_terminator(rest, original, skip, len, acc, @sub_component)
  end

  defp tokenize(<<"\r", rest::binary>>, original, skip, len, acc) do
    tokenize_terminator(rest, original, skip, len, acc, @carriage_return)
  end

  defp tokenize(<<"\n", rest::binary>>, original, skip, len, acc) do
    tokenize_terminator(rest, original, skip, len, acc, @carriage_return)
  end

  defp tokenize(<<_char::binary-size(1), rest::binary>>, original, skip, len, acc) do
    tokenize(rest, original, skip, len + 1, acc)
  end

  defp tokenize("", _original, _skip, 0, acc) do
    Enum.reverse(acc)
  end

  defp tokenize("", original, skip, len, acc) do
    string = binary_part(original, skip, len) |> :binary.copy()
    Enum.reverse([string | acc])
  end

  defp tokenize_terminator(text, original, skip, 0, acc, terminator) do
    tokenize(text, original, skip + 1, 0, [terminator | acc])
  end

  defp tokenize_terminator(text, original, skip, len, acc, terminator) do
    string = binary_part(original, skip, len) |> :binary.copy()
    tokenize(text, original, skip + len + 1, 0, [terminator, string | acc])
  end

  @compile {:inline, tokenize: 5, tokenize_terminator: 6}
end
