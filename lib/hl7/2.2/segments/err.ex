defmodule Hl7.V2_2.Segments.ERR do
  @moduledoc """
  HL7 segment data structure for "ERR"
  """

  require Logger

  use Hl7.Segment,
    fields: [
      segment: nil,
      error_code_and_location: nil
    ]
end
