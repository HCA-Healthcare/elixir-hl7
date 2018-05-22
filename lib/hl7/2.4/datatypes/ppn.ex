defmodule Hl7.V2_4.DataTypes.Ppn do
  @moduledoc """
  The "PPN" (PPN) data type
  """
  alias Hl7.V2_4.{DataTypes}

  use Hl7.DataType,
    fields: [
      id_number_st: nil,
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
      code_identifying_the_check_digit_scheme_employed: nil,
      identifier_type_code_is: nil,
      assigning_facility: DataTypes.Hd,
      datetime_action_performed: DataTypes.Ts,
      name_representation_code: nil,
      name_context: DataTypes.Ce,
      name_validity_range: DataTypes.Dr,
      name_assembly_order: nil
    ]
end
