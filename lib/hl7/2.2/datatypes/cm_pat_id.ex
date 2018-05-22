defmodule Hl7.V2_2.DataTypes.Cmpatid do
  @moduledoc """
  The "CM_PAT_ID" (CM_PAT_ID) data type
  """

  use Hl7.DataType,
    fields: [
      patient_id: nil,
      check_digit: nil,
      check_digit_scheme: nil,
      facility_id: nil,
      type: nil
    ]
end
