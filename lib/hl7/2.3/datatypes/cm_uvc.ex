defmodule HL7.V2_3.DataTypes.Cmuvc do
  @moduledoc """
  The "CM_UVC" (CM_UVC) data type
  """

  use HL7.DataType,
    fields: [
      value_code: nil,
      value_amount: nil
    ]
end
