defmodule HL7.V2_5_1.DataTypes.Ad do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
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
