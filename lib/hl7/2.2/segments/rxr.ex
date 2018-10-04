defmodule HL7.V2_2.Segments.RXR do
  @moduledoc """
  HL7 segment data structure for "RXR"
  """

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      route: DataTypes.Ce,
      site: DataTypes.Ce,
      administration_device: DataTypes.Ce,
      administration_method: DataTypes.Ce
    ]
end
