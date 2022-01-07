defmodule HL7.Parser do
  @carriage_return 4
  @field 3
  @repetition 2
  @component 1
  @sub_component 0

  def parse(<<"MSH|^~\\&", rest::binary()>> = text) do
    tokenize(rest, text, 8, 0, ["^~\\&", @field, "|", @field, "MSH"])
  end

  def tokenize(<<char::binary-size(1), rest::binary>>, original, skip, len, acc) do
    case char do
      "|" -> tokenize_terminator(rest, original, skip, len, acc, @field)
      "~" -> tokenize_terminator(rest, original, skip, len, acc, @repetition)
      "^" -> tokenize_terminator(rest, original, skip, len, acc, @component)
      "&" -> tokenize_terminator(rest, original, skip, len, acc, @sub_component)
      "\r" -> tokenize_terminator(rest, original, skip, len, acc, @carriage_return)
      "\n" -> tokenize_terminator(rest, original, skip, len, acc, @carriage_return)
      _ -> tokenize(rest, original, skip, len + 1, acc)
    end
  end

  def tokenize("", _original, _skip, 0, acc) do
    Enum.reverse(acc)
  end

  def tokenize("", original, skip, len, acc) do
    string = binary_part(original, skip, len)
    Enum.reverse([string | acc])
  end

  def tokenize_terminator(text, original, skip, 0, acc, terminator) do
    tokenize(text, original, skip + 1, 0, [terminator | acc])
  end

  def tokenize_terminator(text, original, skip, len, acc, terminator) do
    string = binary_part(original, skip, len)
    tokenize(text, original, skip + len + 1, 0, [terminator, string | acc])
  end

  def to_lists(tokens) do

    split_by(tokens, @carriage_return)
    |> Enum.reject(& &1 == [])
    |> Enum.map(&to_segment/1)

  end

  def to_segment(tokens) do

    split_by(tokens, @field)
    |> Enum.map(&to_field/1)

  end

  def to_field([]) do
    ""
  end

  def to_field([text]) when is_binary(text) do
    text
  end

  def to_field(tokens) do
    split_by(tokens, @repetition)
    |> Enum.map(&to_repetition/1)
  end

  def to_repetition([]) do
    ""
  end

  def to_repetition([token]) do
    token
  end

  def to_repetition(tokens) do
    split_by(tokens, @component)
    |> Enum.map(&to_component/1)
  end

  def to_component([]) do
    ""
  end

  def to_component([token]) do
    token
  end

  def to_component(tokens) do
    split_by(tokens, @sub_component)
    |> Enum.map(&to_sub_component/1)
  end

  def to_sub_component([]) do
    ""
  end

  def to_sub_component([token]) do
    token
  end

  def split_by(tokens, delimiter) do
    split_by(tokens, delimiter, [], [])
  end

  def split_by([], _delimiter, buffer, result) do
    Enum.reverse([Enum.reverse(buffer) | result])
  end

  def split_by([delimiter | rest], delimiter, buffer, result) do
    split_by(rest, delimiter, [], [Enum.reverse(buffer) | result])
  end

  def split_by([token | rest], delimiter, buffer, result) do
    split_by(rest, delimiter, [token | buffer], result)
  end

  @compile {:inline, tokenize: 5, tokenize_terminator: 6, split_by: 2, split_by: 4}

end
