defmodule Hl7.V2_2.Segments.EVN do
  @moduledoc """
  HL7 segment data structure for "EVN"
  """

  require Logger
  alias Hl7.V2_2.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      event_type_code: nil,
      date_time_of_event: DataTypes.Ts,
      date_time_planned_event: DataTypes.Ts,
      event_reason_code: nil,
      operator_id: nil
    ]
end
