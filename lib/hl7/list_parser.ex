defmodule HL7.Parser do
  @carriage_return 4
  @field 3
  @repetition 2
  @component 1
  @sub_component 0

  def parse(text) do
    HL7.Tokenizer.tokenize(text)
    |> to_lists()
  end

  def parse(text, separators) do
    HL7.DynamicTokenizer.tokenize(text, separators)
    |> to_lists()
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

  defp to_repetition([token]) when is_binary(token) do
    token
  end

  defp to_repetition(tokens) do
    split_by(tokens, @component)
    |> Enum.map(&to_component/1)
  end

  defp to_component([]) do
    ""
  end

  defp to_component([token]) when is_binary(token) do
    token
  end

  defp to_component(tokens) do
    split_by(tokens, @sub_component)
    |> Enum.map(&to_sub_component/1)
  end

  defp to_sub_component([]) do
    ""
  end

  defp to_sub_component([token]) when is_binary(token) do
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

  @compile {:inline,
            split_by: 2,
            split_by: 4,
            to_lists: 1,
            to_segment: 1,
            to_field: 1,
            to_repetition: 1,
            to_component: 1,
            to_sub_component: 1}
end
