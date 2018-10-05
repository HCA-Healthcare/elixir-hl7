defmodule HL7.V2_5.DataTypes.Icd do
  @moduledoc false
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
			certification_patient_type: nil,
			certification_required: nil,
			datetime_certification_required: DataTypes.Ts
    ]
end
