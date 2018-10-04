defmodule HL7.V2_5_1.DataTypes.Rpt do
  @moduledoc """
  The "RPT" (RPT) data type
  """
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
      repeat_pattern_code: DataTypes.Cwe,
      calendar_alignment: nil,
      phase_range_begin_value: nil,
      phase_range_end_value: nil,
      period_quantity: nil,
      period_units: nil,
      institution_specified_time: nil,
      event: nil,
      event_offset_quantity: nil,
      event_offset_units: nil,
      general_timing_specification: nil
    ]
end
