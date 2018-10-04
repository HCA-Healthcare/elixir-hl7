defmodule HL7.V2_2.DataTypes.Pn do
  @moduledoc """
  The "PN" (PN) data type
  """

  use HL7.DataType,
    fields: [
      familiy_name: nil,
      given_name: nil,
      middle_initial_or_name: nil,
      suffix_eg_jr_or_iii: nil,
      prefix_eg_dr: nil,
      degree_eg_md: nil
    ]
end
