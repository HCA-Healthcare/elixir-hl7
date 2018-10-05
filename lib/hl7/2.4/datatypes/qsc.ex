defmodule HL7.V2_4.DataTypes.Qsc do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			segment_field_name: nil,
			relational_operator: nil,
			value: nil,
			relational_conjunction: nil
    ]
end
