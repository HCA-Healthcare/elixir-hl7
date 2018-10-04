defmodule HL7.V2_4.DataTypes.Pta do
  @moduledoc """
  The "PTA" (PTA) data type
  """

  use HL7.DataType,
    fields: [
      policy_type: nil,
      amount_class: nil,
      amount: nil
    ]
end
