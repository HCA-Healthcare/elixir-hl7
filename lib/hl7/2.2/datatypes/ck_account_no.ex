defmodule HL7.V2_2.DataTypes.Ckaccountno do
  @moduledoc """
  The "CK_ACCOUNT_NO" (CK_ACCOUNT_NO) data type
  """

  use HL7.DataType,
    fields: [
      account_number: nil,
      check_digit: nil,
      check_digit_scheme: nil,
      facility_id: nil
    ]
end
