defmodule HL7.V2_3_1.DataTypes.Uvc do
  @moduledoc """
  The "UVC" (UVC) data type
  """

  use HL7.DataType,
    fields: [
      value_code: nil,
      value_amount: nil
    ]
end
