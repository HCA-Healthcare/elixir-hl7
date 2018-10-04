defmodule HL7.V2_5.DataTypes.Xtn do
  @moduledoc """
  The "XTN" (XTN) data type
  """

  use HL7.DataType,
    fields: [
      telephone_number: nil,
      telecommunication_use_code: nil,
      telecommunication_equipment_type: nil,
      email_address: nil,
      country_code: nil,
      areacity_code: nil,
      local_number: nil,
      extension: nil,
      any_text: nil,
      extension_prefix: nil,
      speed_dial_code: nil,
      unformatted_telephone_number: nil
    ]
end
