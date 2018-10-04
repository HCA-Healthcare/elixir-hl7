defmodule HL7.V2_1.Segments.NCK do
  @moduledoc """
  HL7 segment data structure for "NCK"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      system_date_time: nil
    ]
end
