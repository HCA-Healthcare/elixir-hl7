defmodule Hl7.V2_5_1.DataTypes.Icd do
  @moduledoc """
  The "ICD" (ICD) data type
  """
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      certification_patient_type: nil,
      certification_required: nil,
      datetime_certification_required: DataTypes.Ts
    ]
end
