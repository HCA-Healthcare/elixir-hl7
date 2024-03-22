defmodule HL7.HPathParser do
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

  segment_id = ascii_string([?A..?Z], 3) |> tag(:segment)

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
    |> eos(),
    export_metadata: true
  )
end
