defmodule HL7.V2_3_1.Segments.QAK do
  @moduledoc false

  require Logger
  
  use HL7.Segment,
    fields: [
      segment: nil,
			query_tag: nil,
			query_response_status: nil
    ]
end
