defmodule HL7.V2_5.DataTypes.Msg do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			message_code: nil,
			trigger_event: nil,
			message_structure: nil
    ]
end
