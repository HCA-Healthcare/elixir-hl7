defmodule HL7.V2_3.DataTypes.Cmpcf do
  @moduledoc """
  The "CM_PCF" (CM_PCF) data type
  """
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
      precertification_patient_type: nil,
      precertification_required: nil,
      precertification_windwow: DataTypes.Ts
    ]
end
