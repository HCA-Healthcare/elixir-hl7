defmodule HL7.V2_4.Segments.RXR do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			route: DataTypes.Ce,
			administration_site: DataTypes.Ce,
			administration_device: DataTypes.Ce,
			administration_method: DataTypes.Ce,
			routing_instruction: DataTypes.Ce
    ]
end
