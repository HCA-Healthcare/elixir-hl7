defmodule HL7.V2_3_1.DataTypes.Pcf do
  @moduledoc """
  The "PCF" (PCF) data type
  """
  alias HL7.V2_3_1.{DataTypes}

  use HL7.DataType,
    fields: [
      precertification_patient_type: nil,
      precertification_required: nil,
      precertification_window: DataTypes.Ts
    ]
end
