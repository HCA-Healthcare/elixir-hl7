defmodule HL7.V2_2.DataTypes.Cmpatid0192 do
  @moduledoc """
  The "CM_PAT_ID_0192" (CM_PAT_ID_0192) data type
  """

  use HL7.DataType,
    fields: [
      patient_id: nil,
      check_digit: nil,
      check_digit_scheme: nil,
      facility_id: nil,
      type: nil
    ]
end
