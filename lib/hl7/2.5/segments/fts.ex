defmodule HL7.V2_5.Segments.FTS do
  @moduledoc false

  require Logger
  
  use HL7.Segment,
    fields: [
      segment: nil,
			file_batch_count: nil,
			file_trailer_comment: nil
    ]
end
