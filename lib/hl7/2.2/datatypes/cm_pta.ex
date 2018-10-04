defmodule HL7.V2_2.DataTypes.Cmpta do
  @moduledoc """
  The "CM_PTA" (CM_PTA) data type
  """

  use HL7.DataType,
    fields: [
      policy_type: nil,
      amount_class: nil,
      amount: nil
    ]
end
