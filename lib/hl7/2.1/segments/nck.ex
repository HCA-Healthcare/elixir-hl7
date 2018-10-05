defmodule HL7.V2_1.Segments.NCK do
  @moduledoc false

  require Logger
  
  use HL7.Segment,
    fields: [
      segment: nil,
			system_date_time: nil
    ]
end
