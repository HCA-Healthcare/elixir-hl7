defmodule HL7.V2_5.DataTypes.La2 do
  @moduledoc false
  alias HL7.V2_5.{DataTypes}

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
