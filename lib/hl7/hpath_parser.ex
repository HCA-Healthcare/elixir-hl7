defmodule HL7.HPathParser do
  @moduledoc """
  An HL7 Path is defined as:

  SEG[SEG_NUM]-F[R][[.C].S]

  where:

  SEG – a 3 character segment name. For example PID.

  [SEG_NUM] – SEG_NUM is an integer value where SEG_NUM>0 or SEG_NUM='*'. If [SEG_NUM] is omitted, [*] is assumed. If [SEG_NUM]='*', all matching segments are included in the search. For example, OBR[2] means the second OBR segment.

  F – is an integer value where F>0. For example, PID-3 means the 3rd field in the PID segment.

  [R]– is the repetition (of the field) where R > 0 or R = '*'. If R = '*' all repeating fields are included in the query. If [R] is omitted, [*] is assumed.

  C – C>0 or is absent. If C is absent, all components in the field are included separated by '^'. For example, PID-3 means PID-3.1 +PID-3.2+PID-3.3...PID-3.N.

  S – S>0 or is absent. If S is absent, all subcomponents in the component are included separated by '&'. If S is omitted, S=1 is assumed. For example, PID-3.2.3 means the third subcomponent of the component of PID-3, and PID-3.2 means PID-3.2.1+PID-3.2.2+PID-3.2.3...PID-3.2.N.
  """
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
