defmodule HL7.V2_2.DataTypes.Cqquantity do
  @moduledoc """
  The "CQ_QUANTITY" (CQ_QUANTITY) data type
  """

  use HL7.DataType,
    fields: [
      quantity: nil,
      units: nil
    ]
end
