defmodule Hl7.V2_3.Segments.FTS do
  @moduledoc """
  HL7 segment data structure for "FTS"
  """

  require Logger

  use Hl7.Segment,
    fields: [
      segment: nil,
      file_batch_count: nil,
      file_trailer_comment: nil
    ]
end
