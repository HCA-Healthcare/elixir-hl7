defmodule Hl7.V2_4.DataTypes.Msg do
  @moduledoc """
  The "MSG" (MSG) data type
  """

  use Hl7.DataType,
    fields: [
      message_type: nil,
      trigger_event: nil,
      message_structure: nil
    ]
end
