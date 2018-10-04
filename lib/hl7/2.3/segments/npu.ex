defmodule HL7.V2_3.Segments.NPU do
  @moduledoc """
  HL7 segment data structure for "NPU"
  """

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      bed_location: DataTypes.Pl,
      bed_status: nil
    ]
end
