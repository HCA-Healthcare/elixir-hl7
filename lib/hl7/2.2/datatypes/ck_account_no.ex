defmodule HL7.V2_2.DataTypes.Ckaccountno do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			account_number: nil,
			check_digit: nil,
			check_digit_scheme: nil,
			facility_id: nil
    ]
end
