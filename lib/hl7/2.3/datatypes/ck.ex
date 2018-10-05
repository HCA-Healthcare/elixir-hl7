defmodule HL7.V2_3.DataTypes.Ck do
  @moduledoc false
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
			id_number_nm: nil,
			check_digit: nil,
			code_identifying_the_check_digit_scheme_employed: nil,
			assigning_authority: DataTypes.Hd
    ]
end
