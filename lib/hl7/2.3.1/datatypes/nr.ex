defmodule HL7.V2_3_1.DataTypes.Nr do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			low_value: nil,
			high_value: nil
    ]
end
