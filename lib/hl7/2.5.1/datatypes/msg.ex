defmodule Hl7.V2_5_1.DataTypes.Msg do
  @moduledoc """
  The "MSG" (MSG) data type
  """

  use Hl7.DataType,
    fields: [
      message_code: nil,
      trigger_event: nil,
      message_structure: nil
    ]
end
