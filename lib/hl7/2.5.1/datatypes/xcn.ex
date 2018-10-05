defmodule HL7.V2_5_1.DataTypes.Xcn do
  @moduledoc false
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
			id_number: nil,
			family_name: DataTypes.Fn,
			given_name: nil,
			second_and_further_given_names_or_initials_thereof: nil,
			suffix_eg_jr_or_iii: nil,
			prefix_eg_dr: nil,
			degree_eg_md: nil,
			source_table: nil,
			assigning_authority: DataTypes.Hd,
			name_type_code: nil,
			identifier_check_digit: nil,
			check_digit_scheme: nil,
			identifier_type_code: nil,
			assigning_facility: DataTypes.Hd,
			name_representation_code: nil,
			name_context: DataTypes.Ce,
			name_validity_range: DataTypes.Dr,
			name_assembly_order: nil,
			effective_date: DataTypes.Ts,
			expiration_date: DataTypes.Ts,
			professional_suffix: nil,
			assigning_jurisdiction: DataTypes.Cwe,
			assigning_agency_or_department: DataTypes.Cwe
    ]
end
