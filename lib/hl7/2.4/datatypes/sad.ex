defmodule HL7.V2_4.DataTypes.Sad do
  @moduledoc false

  use HL7.DataType,
    fields: [
      street_or_mailing_address: nil,
      street_name: nil,
      dwelling_number: nil
    ]
end
