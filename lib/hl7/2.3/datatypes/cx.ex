defmodule Hl7.V2_3.DataTypes.Cx do
  @moduledoc """
  The "CX" (CX) data type
  """
  alias Hl7.V2_3.{DataTypes}

  use Hl7.DataType,
    fields: [
      id: nil,
      check_digit: nil,
      code_identifying_the_check_digit_scheme_employed: nil,
      assigning_authority: DataTypes.Hd,
      identifier_type_code: nil,
      assigning_facility: DataTypes.Hd
    ]
end
