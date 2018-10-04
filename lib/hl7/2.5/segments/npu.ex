defmodule HL7.V2_5.Segments.NPU do
  @moduledoc """
  HL7 segment data structure for "NPU"
  """

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      bed_location: DataTypes.Pl,
      bed_status: nil
    ]
end
