defmodule HL7.V2_5_1.DataTypes.Cx do
  @moduledoc false
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
			id_number: nil,
			check_digit: nil,
			check_digit_scheme: nil,
			assigning_authority: DataTypes.Hd,
			identifier_type_code: nil,
			assigning_facility: DataTypes.Hd,
			effective_date: nil,
			expiration_date: nil,
			assigning_jurisdiction: DataTypes.Cwe,
			assigning_agency_or_department: DataTypes.Cwe
    ]
end
