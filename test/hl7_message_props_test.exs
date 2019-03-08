defmodule HL7MessagePropsTest do
  use ExUnit.Case
  use PropCheck

  property "parses HL7 message and to_strings back the same" do
    numtests(
      200,
      forall msg <- message() do
        msg
        |> HL7.Message.new()
        |> to_string() == msg
      end
    )
  end

  property "parses a segment for each line in message" do
    forall msg <- message() do
      line_count =
        msg
        |> String.split("\r")
        |> length()

      msg
      |> HL7.Message.new()
      |> (fn m -> m.segments end).()
      |> length() == line_count - 1
    end
  end

  # Helpers

  defp message() do
    let separators <- separators() do
      let {msh_segment, segments} <- {
            msh(separators),
            zero_or_more(segment(separators))
          } do
        ([msh_segment | segments] ++ [""])
        |> Enum.join("\r")
      end
    end
  end

  defp separators() do
    let seps <- such_that(seps <- list_of(separator(), 5), when: unique?(seps)) do
      seps |> to_string
    end
  end

  defp unique?(list) do
    list
    |> MapSet.new()
    |> MapSet.size() == length(list)
  end

  defp separator() do
    # printable characters excluding capital letters and digits
    oneof([
      range(33, 47),
      range(58, 64),
      range(91, 126)
    ])
  end

  defp msh(separators) do
    field_separator = String.first(separators)

    let fields <- list_of(field(separators), 10) do
      joined =
        fields
        |> Enum.join(field_separator)

      "MSH#{separators}#{field_separator}#{joined}"
    end
  end

  defp segment(separators) do
    field_separator = String.first(separators)

    let {name, strings} <- {segment_name(), fields(separators)} do
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

    let strings <- zero_or_more(subgen) do
      strings
      |> Enum.join(separator)
    end
  end

  defp zero_or_more(gen) do
    let count <- range(1, 10) do
      let tup <- oneof([tuple(list_of(gen, count)), {}]) do
        tup
        |> Tuple.to_list()
      end
    end
  end

  defp list_of(value, n), do: 1..n |> Enum.map(fn _ -> value end)

  defp segment_name() do
    let tup <- tuple([capital(), capital_or_digit(), capital_or_digit()]) do
      tup
      |> Tuple.to_list()
      |> Enum.join("")
    end
  end

  defp capital() do
    let char <- range(65, 90) do
      [char] |> to_string
    end
  end

  defp digit() do
    let char <- range(48, 57) do
      [char] |> to_string
    end
  end

  defp capital_or_digit() do
    oneof([capital(), digit()])
  end

  defp safe_string(separators) do
    let str <- such_that(bin <- binary(), when: is_safe?(bin)) do
      str |> escape_separators(separators)
    end
  end

  defp is_safe?(str) do
    [0, 13]
    |> Enum.map(fn char -> to_string([char]) end)
    |> Enum.all?(fn char -> not String.contains?(str, char) end)
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
