defmodule Hl7.V2_2.Segments.RXC do
  @moduledoc """
  HL7 segment data structure for "RXC"
  """

  require Logger
  alias Hl7.V2_2.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      rx_component_type: nil,
      component_code: DataTypes.Ce,
      component_amount: nil,
      component_units: DataTypes.Ce
    ]
end
