defmodule HL7.V2_2.DataTypes.Cmpcf do
  @moduledoc false
  alias HL7.V2_2.{DataTypes}

  use HL7.DataType,
    fields: [
			precertification_patient_type: nil,
			precertication_required: nil,
			precertification_window: DataTypes.Ts
    ]
end
