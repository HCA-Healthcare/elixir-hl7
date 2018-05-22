defmodule Hl7.V2_5_1.DataTypes.La2 do
  @moduledoc """
  The "LA2" (LA2) data type
  """
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      point_of_care: nil,
      room: nil,
      bed: nil,
      facility: DataTypes.Hd,
      location_status: nil,
      patient_location_type: nil,
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
