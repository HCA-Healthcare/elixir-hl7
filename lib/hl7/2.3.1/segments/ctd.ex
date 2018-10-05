defmodule HL7.V2_3_1.Segments.CTD do
  @moduledoc false

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			contact_role: DataTypes.Ce,
			contact_name: DataTypes.Xpn,
			contact_address: DataTypes.Xad,
			contact_location: DataTypes.Pl,
			contact_communication_information: DataTypes.Xtn,
			preferred_method_of_contact: DataTypes.Ce,
			contact_identifiers: DataTypes.Pi
    ]
end
