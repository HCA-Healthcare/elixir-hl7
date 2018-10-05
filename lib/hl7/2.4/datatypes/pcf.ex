defmodule HL7.V2_4.DataTypes.Pcf do
  @moduledoc false
  alias HL7.V2_4.{DataTypes}

  use HL7.DataType,
    fields: [
      precertification_patient_type: nil,
      precertification_required: nil,
      precertification_window: DataTypes.Ts
    ]
end
