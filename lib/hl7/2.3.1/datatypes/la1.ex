defmodule Hl7.V2_3_1.DataTypes.La1 do
  @moduledoc """
  The "LA1" (LA1) data type
  """
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      point_of_care_is: nil,
      room: nil,
      bed: nil,
      facility_hd: DataTypes.Hd,
      location_status: nil,
      person_location_type: nil,
      building: nil,
      floor: nil,
      address: DataTypes.Ad
    ]
end
