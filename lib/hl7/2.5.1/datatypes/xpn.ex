defmodule HL7.V2_5_1.DataTypes.Xpn do
  @moduledoc false
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
      family_name: DataTypes.Fn,
      given_name: nil,
      second_and_further_given_names_or_initials_thereof: nil,
      suffix_eg_jr_or_iii: nil,
      prefix_eg_dr: nil,
      degree_eg_md: nil,
      name_type_code: nil,
      name_representation_code: nil,
      name_context: DataTypes.Ce,
      name_validity_range: DataTypes.Dr,
      name_assembly_order: nil,
      effective_date: DataTypes.Ts,
      expiration_date: DataTypes.Ts,
      professional_suffix: nil
    ]
end
