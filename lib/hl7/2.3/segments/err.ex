defmodule HL7.V2_3.Segments.ERR do
  @moduledoc """
  HL7 segment data structure for "ERR"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      error_code_and_location: nil
    ]
end
