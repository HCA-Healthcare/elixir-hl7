defmodule HL7.V2_4.Segments.ISD do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			reference_interaction_number_unique_identifier: nil,
			interaction_type_identifier: DataTypes.Ce,
			interaction_active_state: DataTypes.Ce
    ]
end
