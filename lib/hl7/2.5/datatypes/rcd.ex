defmodule HL7.V2_5.DataTypes.Rcd do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			segment_field_name: nil,
			hl7_data_type: nil,
			maximum_column_width: nil
    ]
end
