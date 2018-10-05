defmodule HL7.V2_4.DataTypes.Msg do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			message_type: nil,
			trigger_event: nil,
			message_structure: nil
    ]
end
