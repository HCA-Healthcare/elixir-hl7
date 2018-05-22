defmodule Hl7.V2_3.DataTypes.Cmmsg do
  @moduledoc """
  The "CM_MSG" (CM_MSG) data type
  """

  use Hl7.DataType,
    fields: [
      message_type: nil,
      trigger_event: nil
    ]
end
