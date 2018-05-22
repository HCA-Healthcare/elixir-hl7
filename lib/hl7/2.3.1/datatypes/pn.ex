defmodule Hl7.V2_3_1.DataTypes.Pn do
  @moduledoc """
  The "PN" (PN) data type
  """
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      familylast_name: DataTypes.Fn,
      given_name: nil,
      middle_initial_or_name: nil,
      suffix_eg_jr_or_iii: nil,
      prefix_eg_dr: nil,
      degree_eg_md: nil
    ]
end
