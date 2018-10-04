defmodule HL7.V2_1.Segments.NPU do
  @moduledoc """
  HL7 segment data structure for "NPU"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      bed_location: nil,
      bed_status: nil
    ]
end
