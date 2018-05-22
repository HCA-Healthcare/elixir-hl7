defmodule Hl7.V2_4.DataTypes.Xpn do
  @moduledoc """
  The "XPN" (XPN) data type
  """
  alias Hl7.V2_4.{DataTypes}

  use Hl7.DataType,
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
      name_assembly_order: nil
    ]
end
