defmodule HL7.V2_2.DataTypes.Cmpatid0192 do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			patient_id: nil,
			check_digit: nil,
			check_digit_scheme: nil,
			facility_id: nil,
			type: nil
    ]
end
