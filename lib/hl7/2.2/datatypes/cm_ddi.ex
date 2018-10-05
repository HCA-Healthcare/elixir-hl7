defmodule HL7.V2_2.DataTypes.Cmddi do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			delay_days: nil,
			amount: nil,
			number_of_days: nil
    ]
end
