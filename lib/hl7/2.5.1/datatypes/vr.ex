defmodule HL7.V2_5_1.DataTypes.Vr do
  @moduledoc """
  The "VR" (VR) data type
  """

  use HL7.DataType,
    fields: [
      first_data_code_value: nil,
      last_data_code_value: nil
    ]
end
