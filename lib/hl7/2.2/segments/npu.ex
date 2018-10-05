defmodule HL7.V2_2.Segments.NPU do
  @moduledoc false

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      bed_location: nil,
      bed_status: nil
    ]
end
