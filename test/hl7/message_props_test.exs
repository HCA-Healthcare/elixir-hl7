defmodule HL7.MessagePropsTest do
  use ExUnit.Case
  use ExUnitProperties

  property "parses HL7 message and to_strings back the same" do
    check all msg <- message() do
      msg
      |> HL7.Message.new()
      |> to_string() == msg
    end
  end

  property "parses a segment for each line in message" do
    check all msg <- message() do
      line_count =
        msg
        |> String.split("\r")
        |> length()

      %HL7.Message{segments: segments} = HL7.Message.new(msg)
      length(segments) == line_count - 1
    end
  end

  # Helpers

  defp message() do
    gen all separators <- one_of([separators(), separators(6)]),
            msh_segment <- msh(separators),
            segments <- list_of(segment(separators), min_length: 0, max_length: 10) do
      [msh_segment | segments]
      |> Enum.join("\r")
    end
  end

  defp separators(length \\ 5) do
    gen all seps <- uniq_list_of(separator(), length: length) do
      seps |> to_string
    end
  end

  defp separator() do
    # printable characters excluding capital letters and digits
    one_of([
      integer(?!..?/),
      integer(?:..?@),
      integer(?[..?~)
    ])
  end

  defp msh(separators) do
    field_separator = String.first(separators)

    gen all fields6 <- list_of(field(separators), length: 6),
            message_type <- message_type(separators),
            fields4 <- list_of(field(separators), length: 4) do
      joined =
        fields6
        |> Enum.concat([message_type | fields4])
        |> Enum.join(field_separator)

      "MSH#{separators}#{field_separator}#{joined}"
    end
  end

  defp segment(separators) do
    field_separator = String.first(separators)

    gen all {name, strings} <- {segment_name(), fields(separators)} do
      "#{name}#{field_separator}#{strings}"
    end
  end

  defp fields(separators) do
    gen_value(separators, 0, field(separators))
  end

  defp field(separators) do
    gen_value(separators, 2, repetition(separators))
  end

  defp repetition(separators) do
    gen_value(separators, 1, component(separators))
  end

  defp component(separators) do
    gen_value(separators, 4, safe_string(separators))
  end

  defp gen_value(separators, separator_index, subgen) do
    separator = separators |> String.at(separator_index)

    gen all strings <- list_of(subgen, min_length: 1, max_length: 10) do
      strings
      |> Enum.join(separator)
    end
  end

  defp message_type(separators) do
    component_separator = separators |> String.at(1)
    repetition_separator = separators |> String.at(2)

    gen all components <- list_of(component(separators), min_length: 2, max_length: 10),
            repetitions <- list_of(repetition(separators), min_length: 0, max_length: 10) do
      first_rep = components |> Enum.join(component_separator)

      [first_rep | repetitions]
      |> Enum.join(repetition_separator)
    end
  end

  defp segment_name() do
    gen all char1 <- capital(), char2 <- capital_or_digit(), char3 <- capital_or_digit() do
      [char1, char2, char3] |> Enum.join("")
    end
  end

  defp capital() do
    gen all char <- integer(?A..?Z) do
      [char] |> to_string
    end
  end

  defp digit() do
    gen all char <- integer(?0..?9) do
      [char] |> to_string
    end
  end

  defp capital_or_digit() do
    one_of([capital(), digit()])
  end

  defp safe_string(separators) do
    gen all chars <- list_of(integer(32..126)) do
      chars
      |> to_string()
      |> escape_separators(separators)
    end
  end

  defp escape_separators(str, separators) do
    escape = separators |> String.at(3)

    separators
    |> String.to_charlist()
    |> Enum.map(fn char -> [char] |> to_string end)
    |> Enum.zip(~w(F S R E T))
    |> Enum.reduce(str, fn {separator, replacement}, acc ->
      String.replace(acc, separator, "#{escape}#{replacement}#{escape}")
    end)
  end
end
