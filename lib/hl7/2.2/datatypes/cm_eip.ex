defmodule Hl7.V2_2.DataTypes.Cmeip do
  @moduledoc """
  The "CM_EIP" (CM_EIP) data type
  """

  use Hl7.DataType,
    fields: [
      parents_placer_order_number: nil,
      parents_filler_order_number: nil
    ]
end
