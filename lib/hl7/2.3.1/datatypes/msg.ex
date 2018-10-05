defmodule HL7.V2_3_1.DataTypes.Msg do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			message_type: nil,
			trigger_event: nil,
			message_structure: nil
    ]
end
