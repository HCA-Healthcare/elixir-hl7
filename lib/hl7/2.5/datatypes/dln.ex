defmodule Hl7.V2_5.DataTypes.Dln do
  @moduledoc """
  The "DLN" (DLN) data type
  """

  use Hl7.DataType,
    fields: [
      license_number: nil,
      issuing_state_province_country: nil,
      expiration_date: nil
    ]
end
