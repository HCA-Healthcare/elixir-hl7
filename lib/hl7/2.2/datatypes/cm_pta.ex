defmodule Hl7.V2_2.DataTypes.Cmpta do
  @moduledoc """
  The "CM_PTA" (CM_PTA) data type
  """

  use Hl7.DataType,
    fields: [
      policy_type: nil,
      amount_class: nil,
      amount: nil
    ]
end
