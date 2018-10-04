defmodule HL7.V2_5.DataTypes.Pl do
  @moduledoc """
  The "PL" (PL) data type
  """
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
      point_of_care: nil,
      room: nil,
      bed: nil,
      facility: DataTypes.Hd,
      location_status: nil,
      person_location_type: nil,
      building: nil,
      floor: nil,
      location_description: nil,
      comprehensive_location_identifier: DataTypes.Ei,
      assigning_authority_for_location: DataTypes.Hd
    ]
end
