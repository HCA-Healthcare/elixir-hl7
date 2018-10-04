defmodule HL7.V2_1.Segments.NTE do
  @moduledoc """
  HL7 segment data structure for "NTE"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_notes_and_comments: nil,
      source_of_comment: nil,
      comment: nil
    ]
end
