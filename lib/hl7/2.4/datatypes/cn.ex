defmodule HL7.V2_4.DataTypes.Cn do
  @moduledoc false
  alias HL7.V2_4.{DataTypes}

  use HL7.DataType,
    fields: [
			id_number_st: nil,
			family_name: DataTypes.Fn,
			given_name: nil,
			second_and_further_given_names_or_initials_thereof: nil,
			suffix_eg_jr_or_iii: nil,
			prefix_eg_dr: nil,
			degree_eg_md: nil,
			source_table: nil,
			assigning_authority: DataTypes.Hd
    ]
end
