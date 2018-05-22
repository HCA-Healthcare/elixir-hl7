defmodule Hl7.V2_4.DataTypes.Rmc do
  @moduledoc """
  The "RMC" (RMC) data type
  """

  use Hl7.DataType,
    fields: [
      room_type: nil,
      amount_type: nil,
      coverage_amount: nil
    ]
end
