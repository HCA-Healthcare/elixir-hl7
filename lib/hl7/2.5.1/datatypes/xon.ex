defmodule HL7.V2_5_1.DataTypes.Xon do
  @moduledoc """
  The "XON" (XON) data type
  """
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
      organization_name: nil,
      organization_name_type_code: nil,
      id_number: nil,
      check_digit: nil,
      check_digit_scheme: nil,
      assigning_authority: DataTypes.Hd,
      identifier_type_code: nil,
      assigning_facility: DataTypes.Hd,
      name_representation_code: nil,
      organization_identifier: nil
    ]
end
