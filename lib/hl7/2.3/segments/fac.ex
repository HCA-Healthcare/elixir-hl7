defmodule HL7.V2_3.Segments.FAC do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			facility_id: DataTypes.Ei,
			facility_type: nil,
			facility_address: DataTypes.Xad,
			facility_telecommunication: DataTypes.Xtn,
			contact_person: DataTypes.Xcn,
			contact_title: nil,
			contact_address: DataTypes.Xad,
			contact_telecommunication: DataTypes.Xtn,
			signature_authority: DataTypes.Xcn,
			signature_authority_title: nil,
			signature_authority_address: DataTypes.Xad,
			signature_authority_telecommunication: DataTypes.Xtn
    ]
end
