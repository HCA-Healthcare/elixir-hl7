defmodule Hl7.V2_5_1.DataTypes.Pta do
  @moduledoc """
  The "PTA" (PTA) data type
  """
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      policy_type: nil,
      amount_class: nil,
      money_or_percentage_quantity: nil,
      money_or_percentage: DataTypes.Mop
    ]
end
