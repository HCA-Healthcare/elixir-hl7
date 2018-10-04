defmodule HL7.V2_3_1.Segments.EVN do
  @moduledoc """
  HL7 segment data structure for "EVN"
  """

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      event_type_code: nil,
      recorded_date_time: DataTypes.Ts,
      date_time_planned_event: DataTypes.Ts,
      event_reason_code: nil,
      operator_id: DataTypes.Xcn,
      event_occurred: DataTypes.Ts
    ]
end
