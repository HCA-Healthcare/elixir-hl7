defmodule HL7.V2_3_1.Segments.LOC do
  @moduledoc false

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      primary_key_value_loc: DataTypes.Pl,
      location_description: nil,
      location_type_loc: nil,
      organization_name_loc: DataTypes.Xon,
      location_address: DataTypes.Xad,
      location_phone: DataTypes.Xtn,
      license_number: DataTypes.Ce,
      location_equipment: nil
    ]
end
