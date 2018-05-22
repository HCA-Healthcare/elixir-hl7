defmodule Hl7.V2_5.DataTypes.Rmc do
  @moduledoc """
  The "RMC" (RMC) data type
  """
  alias Hl7.V2_5.{DataTypes}

  use Hl7.DataType,
    fields: [
      room_type: nil,
      amount_type: nil,
      coverage_amount: nil,
      money_or_percentage: DataTypes.Mop
    ]
end
