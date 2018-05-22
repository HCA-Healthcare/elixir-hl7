defmodule Hl7.V2_5_1.Segments.NTE do
  @moduledoc """
  HL7 segment data structure for "NTE"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_nte: nil,
      source_of_comment: nil,
      comment: nil,
      comment_type: DataTypes.Ce
    ]
end
