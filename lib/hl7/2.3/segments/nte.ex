defmodule Hl7.V2_3.Segments.NTE do
  @moduledoc """
  HL7 segment data structure for "NTE"
  """

  require Logger

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_notes_and_comments: nil,
      source_of_comment: nil,
      comment: nil
    ]
end
