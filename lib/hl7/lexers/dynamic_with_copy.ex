defmodule HL7.Lexers.DynamicWithCopy do
  @moduledoc false
  @carriage_return 4
  @field 3
  @repetition 2
  @component 1
  @sub_component 0

  def tokenize(text) do
    separators = HL7.Separators.new(text)
    tokenize(text, separators)
  end

  def tokenize(
        <<"MSH", _field_and_encoding::binary-size(5), rest::binary>> = text,
        %HL7.Separators{truncation_char: ""} = separators
      ) do
    %{encoding_characters: encoding_characters, field: field} = separators
    tokenize(rest, text, 8, 0, [encoding_characters, @field, field, @field, "MSH"], separators)
  end

  def tokenize(
        <<"MSH", _field_and_encoding::binary-size(6), rest::binary>> = text,
        %HL7.Separators{} = separators
      ) do
    %{encoding_characters: encoding_characters, field: field} = separators
    tokenize(rest, text, 9, 0, [encoding_characters, @field, field, @field, "MSH"], separators)
  end

  defp tokenize(
         <<field::binary-size(1), rest::binary>>,
         original,
         skip,
         len,
         acc,
         %HL7.Separators{field: field} = separators
       ) do
    tokenize_terminator(rest, original, skip, len, acc, @field, separators)
  end

  defp tokenize(
         <<repetition::binary-size(1), rest::binary>>,
         original,
         skip,
         len,
         acc,
         %HL7.Separators{field_repeat: repetition} = separators
       ) do
    tokenize_terminator(rest, original, skip, len, acc, @repetition, separators)
  end

  defp tokenize(
         <<component::binary-size(1), rest::binary>>,
         original,
         skip,
         len,
         acc,
         %HL7.Separators{component: component} = separators
       ) do
    tokenize_terminator(rest, original, skip, len, acc, @component, separators)
  end

  defp tokenize(
         <<subcomponent::binary-size(1), rest::binary>>,
         original,
         skip,
         len,
         acc,
         %HL7.Separators{subcomponent: subcomponent} = separators
       ) do
    tokenize_terminator(rest, original, skip, len, acc, @sub_component, separators)
  end

  defp tokenize(<<"\r", rest::binary>>, original, skip, len, acc, separators) do
    tokenize_terminator(rest, original, skip, len, acc, @carriage_return, separators)
  end

  defp tokenize(<<"\n", rest::binary>>, original, skip, len, acc, separators) do
    tokenize_terminator(rest, original, skip, len, acc, @carriage_return, separators)
  end

  defp tokenize(<<_char::binary-size(1), rest::binary>>, original, skip, len, acc, separators) do
    tokenize(rest, original, skip, len + 1, acc, separators)
  end

  defp tokenize("", _original, _skip, 0, acc, _separators) do
    Enum.reverse(acc)
  end

  defp tokenize("", original, skip, len, acc, _separators) do
    string = binary_part(original, skip, len) |> :binary.copy()
    Enum.reverse([string | acc])
  end

  defp tokenize_terminator(text, original, skip, 0, acc, terminator, separators) do
    tokenize(text, original, skip + 1, 0, [terminator | acc], separators)
  end

  defp tokenize_terminator(text, original, skip, len, acc, terminator, separators) do
    string = binary_part(original, skip, len) |> :binary.copy()
    tokenize(text, original, skip + len + 1, 0, [terminator, string | acc], separators)
  end

  @compile {:inline, tokenize: 6, tokenize_terminator: 7}
end
