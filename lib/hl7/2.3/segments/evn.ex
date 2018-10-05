defmodule HL7.V2_3.Segments.EVN do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      event_type_code: nil,
      recorded_date_time: DataTypes.Ts,
      date_time_planned_event: DataTypes.Ts,
      event_reason_code: nil,
      operator_id: DataTypes.Cn,
      event_occured: DataTypes.Ts
    ]
end
