defmodule HL7.V2_4.Segments.RXC do
  @moduledoc """
  HL7 segment data structure for "RXC"
  """

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      rx_component_type: nil,
      component_code: DataTypes.Ce,
      component_amount: nil,
      component_units: DataTypes.Ce,
      component_strength: nil,
      component_strength_units: DataTypes.Ce,
      supplementary_code: DataTypes.Ce
    ]
end
