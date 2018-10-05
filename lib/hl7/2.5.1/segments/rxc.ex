defmodule HL7.V2_5_1.Segments.RXC do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			rx_component_type: nil,
			component_code: DataTypes.Ce,
			component_amount: nil,
			component_units: DataTypes.Ce,
			component_strength: nil,
			component_strength_units: DataTypes.Ce,
			supplementary_code: DataTypes.Ce,
			component_drug_strength_volume: nil,
			component_drug_strength_volume_units: DataTypes.Cwe
    ]
end
