defmodule HL7.V2_3_1.DataTypes.Pta do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			policy_type: nil,
			amount_class: nil,
			amount: nil
    ]
end
