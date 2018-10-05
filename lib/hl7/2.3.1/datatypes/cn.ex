defmodule HL7.V2_3_1.DataTypes.Cn do
  @moduledoc false
  alias HL7.V2_3_1.{DataTypes}

  use HL7.DataType,
    fields: [
      id_number_st: nil,
      family_name: nil,
      given_name: nil,
      middle_initial_or_name: nil,
      suffix_eg_jr_or_iii: nil,
      prefix_eg_dr: nil,
      degree_eg_md: nil,
      source_table: nil,
      assigning_authority: DataTypes.Hd
    ]
end
