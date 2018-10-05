defmodule HL7.V2_5.DataTypes.Vh do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			start_day_range: nil,
			end_day_range: nil,
			start_hour_range: nil,
			end_hour_range: nil
    ]
end
