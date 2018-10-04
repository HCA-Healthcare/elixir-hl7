defmodule HL7.V2_4.DataTypes.Vr do
  @moduledoc """
  The "VR" (VR) data type
  """

  use HL7.DataType,
    fields: [
      first_data_code_value: nil,
      last_data_code_calue: nil
    ]
end
