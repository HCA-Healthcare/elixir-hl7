defmodule Hl7.V2_5.Segments.ODT do
  @moduledoc """
  HL7 segment data structure for "ODT"
  """

  require Logger
  alias Hl7.V2_5.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      tray_type: DataTypes.Ce,
      service_period: DataTypes.Ce,
      text_instruction: nil
    ]
end
