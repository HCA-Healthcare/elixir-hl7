defmodule HL7.V2_5_1.Segments.RXR do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			route: DataTypes.Ce,
			administration_site: DataTypes.Cwe,
			administration_device: DataTypes.Ce,
			administration_method: DataTypes.Cwe,
			routing_instruction: DataTypes.Ce,
			administration_site_modifier: DataTypes.Cwe
    ]
end
