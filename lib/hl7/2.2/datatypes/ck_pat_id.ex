defmodule HL7.V2_2.DataTypes.Ckpatid do
  @moduledoc false

  use HL7.DataType,
    fields: [
      patient_id: nil,
      check_digit: nil,
      check_digit_scheme: nil,
      facility_id: nil
    ]
end
