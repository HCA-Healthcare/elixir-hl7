defmodule HL7.V2_5.Segments.TQ1 do
  @moduledoc """
  HL7 segment data structure for "TQ1"
  """

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_tq1: nil,
      quantity: DataTypes.Cq,
      repeat_pattern: DataTypes.Rpt,
      explicit_time: nil,
      relative_time_and_units: DataTypes.Cq,
      service_duration: DataTypes.Cq,
      start_date_time: DataTypes.Ts,
      end_date_time: DataTypes.Ts,
      priority: DataTypes.Cwe,
      condition_text: nil,
      text_instruction: nil,
      conjunction: nil,
      occurrence_duration: DataTypes.Cq,
      total_occurrence_s: nil
    ]
end
