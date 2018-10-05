defmodule HL7.V2_3_1.DataTypes.Ddi do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			delay_days: nil,
			amount: nil,
			number_of_days: nil
    ]
end
