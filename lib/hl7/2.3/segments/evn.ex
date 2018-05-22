defmodule Hl7.V2_3.Segments.EVN do
  @moduledoc """
  HL7 segment data structure for "EVN"
  """

  require Logger
  alias Hl7.V2_3.{DataTypes}

  use Hl7.Segment,
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
