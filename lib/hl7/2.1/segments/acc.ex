defmodule Hl7.V2_1.Segments.ACC do
  @moduledoc """
  HL7 segment data structure for "ACC"
  """

  require Logger

  use Hl7.Segment,
    fields: [
      segment: nil,
      accident_date_time: nil,
      accident_code: nil,
      accident_location: nil
    ]
end
