defmodule HL7.V2_2.DataTypes.Cmlicenseno do
  @moduledoc """
  The "CM_LICENSE_NO" (CM_LICENSE_NO) data type
  """

  use HL7.DataType,
    fields: [
      license_number: nil,
      issuing_stateprovincecountry: nil
    ]
end
