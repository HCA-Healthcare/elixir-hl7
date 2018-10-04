defmodule HL7.V2_3_1.DataTypes.La2 do
  @moduledoc """
  The "LA2" (LA2) data type
  """
  alias HL7.V2_3_1.{DataTypes}

  use HL7.DataType,
    fields: [
      point_of_care_is: nil,
      room: nil,
      bed: nil,
      facility_hd: DataTypes.Hd,
      location_status: nil,
      person_location_type: nil,
      building: nil,
      floor: nil,
      street_address: nil,
      other_designation: nil,
      city: nil,
      state_or_province: nil,
      zip_or_postal_code: nil,
      country: nil,
      address_type: nil,
      other_geographic_designation: nil
    ]
end
