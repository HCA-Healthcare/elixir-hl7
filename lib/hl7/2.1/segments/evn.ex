defmodule HL7.V2_1.Segments.EVN do
  @moduledoc false

  require Logger
  
  use HL7.Segment,
    fields: [
      segment: nil,
			event_type_code: nil,
			date_time_of_event: nil,
			date_time_planned_event: nil,
			event_reason_code: nil
    ]
end
