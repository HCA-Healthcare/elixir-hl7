defmodule HL7.V2_4.DataTypes.Pn do
  @moduledoc false
  alias HL7.V2_4.{DataTypes}

  use HL7.DataType,
    fields: [
      family_name: DataTypes.Fn,
      given_name: nil,
      second_and_further_given_names_or_initials_thereof: nil,
      suffix_eg_jr_or_iii: nil,
      prefix_eg_dr: nil,
      degree_eg_md: nil
    ]
end
