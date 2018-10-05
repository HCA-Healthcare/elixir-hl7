defmodule HL7.V2_5.DataTypes.Csu do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			channel_sensitivity: nil,
			unit_of_measure_identifier: nil,
			unit_of_measure_description: nil,
			unit_of_measure_coding_system: nil,
			alternate_unit_of_measure_identifier: nil,
			alternate_unit_of_measure_description: nil,
			alternate_unit_of_measure_coding_system: nil
    ]
end
