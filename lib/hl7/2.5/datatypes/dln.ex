defmodule HL7.V2_5.DataTypes.Dln do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			license_number: nil,
			issuing_state_province_country: nil,
			expiration_date: nil
    ]
end
