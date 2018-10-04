defmodule HL7.V2_3_1.Segments.NTE do
  @moduledoc """
  HL7 segment data structure for "NTE"
  """

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_nte: nil,
      source_of_comment: nil,
      comment: nil,
      comment_type: DataTypes.Ce
    ]
end
