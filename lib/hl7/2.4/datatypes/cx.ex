defmodule Hl7.V2_4.DataTypes.Cx do
  @moduledoc """
  The "CX" (CX) data type
  """
  alias Hl7.V2_4.{DataTypes}

  use Hl7.DataType,
    fields: [
      id: nil,
      check_digit_st: nil,
      code_identifying_the_check_digit_scheme_employed: nil,
      assigning_authority: DataTypes.Hd,
      identifier_type_code_id: nil,
      assigning_facility: DataTypes.Hd,
      effective_date_dt: nil,
      expiration_date: nil
    ]
end
