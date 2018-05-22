defmodule Hl7.V2_3_1.DataTypes.Mop do
  @moduledoc """
  The "MOP" (MOP) data type
  """

  use Hl7.DataType,
    fields: [
      money_or_percentage_indicator: nil,
      money_or_percentage_quantity: nil
    ]
end
