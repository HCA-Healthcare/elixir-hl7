defmodule HL7.V2_3.DataTypes.Cmmsg do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			message_type: nil,
			trigger_event: nil
    ]
end
