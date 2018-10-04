defmodule HL7.V2_3_1.DataTypes.Cns do
  @moduledoc """
  The "CNS" (CNS) data type
  """

  use HL7.DataType,
    fields: [
      id_number_st: nil,
      family_name: nil,
      given_name: nil,
      second_and_further_given_names_or_initials_thereof: nil,
      suffix_eg_jr_or_iii: nil,
      prefix_eg_dr: nil,
      degree_eg_md: nil,
      source_table: nil,
      assigning_authority_namespace_id: nil,
      assigning_authority_universal_id: nil,
      assigning_authority_universal_id_type: nil
    ]
end
