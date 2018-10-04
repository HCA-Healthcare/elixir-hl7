defmodule HL7.V2_5_1.DataTypes.La1 do
  @moduledoc """
  The "LA1" (LA1) data type
  """
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
      point_of_care: nil,
      room: nil,
      bed: nil,
      facility: DataTypes.Hd,
      location_status: nil,
      patient_location_type: nil,
      building: nil,
      floor: nil,
      address: DataTypes.Ad
    ]
end
