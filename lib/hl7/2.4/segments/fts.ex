defmodule HL7.V2_4.Segments.FTS do
  @moduledoc """
  HL7 segment data structure for "FTS"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      file_batch_count: nil,
      file_trailer_comment: nil
    ]
end
