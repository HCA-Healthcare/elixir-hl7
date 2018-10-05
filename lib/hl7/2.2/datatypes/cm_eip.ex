defmodule HL7.V2_2.DataTypes.Cmeip do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			parents_placer_order_number: nil,
			parents_filler_order_number: nil
    ]
end
