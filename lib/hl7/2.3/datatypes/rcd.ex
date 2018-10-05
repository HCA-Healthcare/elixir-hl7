defmodule HL7.V2_3.DataTypes.Rcd do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			hl7_item_number: nil,
			hl7_date_type: nil,
			maximum_column_width: nil
    ]
end
