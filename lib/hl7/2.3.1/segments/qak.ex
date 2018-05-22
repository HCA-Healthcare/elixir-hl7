defmodule Hl7.V2_3_1.Segments.QAK do
  @moduledoc """
  HL7 segment data structure for "QAK"
  """

  require Logger

  use Hl7.Segment,
    fields: [
      segment: nil,
      query_tag: nil,
      query_response_status: nil
    ]
end
