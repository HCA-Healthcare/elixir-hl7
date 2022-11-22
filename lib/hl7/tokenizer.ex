defmodule HL7.Tokenizer do
  @carriage_return 4
  @field 3
  @repetition 2
  @component 1
  @sub_component 0

  def parse(<<"MSH|^~\\&", rest::binary()>> = text) do
    tokenize(rest, text, 8, 0, ["^~\\&", @field, "|", @field, "MSH"])
    |> to_lists()
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
    string = binary_part(original, skip, len)
    Enum.reverse([string | acc])
  end

  defp tokenize_terminator(text, original, skip, 0, acc, terminator) do
    tokenize(text, original, skip + 1, 0, [terminator | acc])
  end

  defp tokenize_terminator(text, original, skip, len, acc, terminator) do
    string = binary_part(original, skip, len)
    tokenize(text, original, skip + len + 1, 0, [terminator, string | acc])
  end

  defp to_lists(tokens) do
    split_by(tokens, @carriage_return)
    |> Enum.reject(&(&1 == []))
    |> Enum.map(&to_segment/1)
  end

  defp to_segment(tokens) do
    split_by(tokens, @field)
    |> Enum.map(&to_field/1)
  end

  defp to_field([]) do
    ""
  end

  defp to_field([text]) when is_binary(text) do
    text
  end

  defp to_field(tokens) do
    split_by(tokens, @repetition)
    |> Enum.map(&to_repetition/1)
  end

  defp to_repetition([]) do
    ""
  end

  defp to_repetition([token]) do
    token
  end

  defp to_repetition(tokens) do
    split_by(tokens, @component)
    |> Enum.map(&to_component/1)
  end

  defp to_component([]) do
    ""
  end

  defp to_component([token]) do
    token
  end

  defp to_component(tokens) do
    split_by(tokens, @sub_component)
    |> Enum.map(&to_sub_component/1)
  end

  defp to_sub_component([]) do
    ""
  end

  defp to_sub_component([token]) do
    token
  end

  defp split_by(tokens, delimiter) do
    split_by(tokens, delimiter, [], [])
  end

  defp split_by([], _delimiter, buffer, result) do
    Enum.reverse([Enum.reverse(buffer) | result])
  end

  defp split_by([delimiter | rest], delimiter, buffer, result) do
    split_by(rest, delimiter, [], [Enum.reverse(buffer) | result])
  end

  defp split_by([token | rest], delimiter, buffer, result) do
    split_by(rest, delimiter, [token | buffer], result)
  end

  @compile {:inline, tokenize: 5, tokenize_terminator: 6, split_by: 2, split_by: 4}
end
