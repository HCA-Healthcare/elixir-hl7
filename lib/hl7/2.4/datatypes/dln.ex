defmodule HL7.V2_4.DataTypes.Dln do
  @moduledoc false

  use HL7.DataType,
    fields: [
      drivers_license_number: nil,
      issuing_state_province_country: nil,
      expiration_date: nil
    ]
end
