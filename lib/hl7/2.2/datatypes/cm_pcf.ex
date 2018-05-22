defmodule Hl7.V2_2.DataTypes.Cmpcf do
  @moduledoc """
  The "CM_PCF" (CM_PCF) data type
  """
  alias Hl7.V2_2.{DataTypes}

  use Hl7.DataType,
    fields: [
      precertification_patient_type: nil,
      precertication_required: nil,
      precertification_window: DataTypes.Ts
    ]
end
