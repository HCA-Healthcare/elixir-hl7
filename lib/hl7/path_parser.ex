defmodule HL7.PathParser do
  import NimbleParsec

  numeric_index = integer(min: 1)
  index = choice([numeric_index, string("*")])

  bracketed_num =
    ignore(string("["))
    |> concat(index)
    |> ignore(string("]"))

  defaulted_num = choice([bracketed_num, empty() |> replace(1)])

  dot = ignore(string("."))
  dash = ignore(string("-"))

  bang = string("!") |> replace(true) |> tag(:truncate)

  field = optional(dash) |> concat(index) |> tag(:field)

  alpha = ascii_string([?A..?Z], 1)
  alpha_num = choice([ascii_string([?0..?9], 1), alpha])

  segment_id =
    alpha
    |> concat(alpha_num)
    |> concat(alpha_num)
    |> reduce({Enum, :join, [""]})
    |> tag(:segment)

  segment_num = defaulted_num |> tag(:segment_number)

  segment_header = optional(segment_id |> concat(segment_num))

  repeat_num = defaulted_num |> tag(:repetition)

  component = index |> tag(:component)

  subcomponent = index |> tag(:subcomponent)

  component_part =
    dot
    |> concat(component)
    |> optional(concat(dot, subcomponent))

  defparsec(
    :parse,
    segment_header
    |> optional(field)
    |> optional(repeat_num)
    |> optional(component_part)
    |> optional(bang)
    |> eos()
  )
end
