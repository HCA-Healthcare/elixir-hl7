defmodule HL7.V2_5.DataTypes.Mo do
  @moduledoc """
  The "MO" (MO) data type
  """

  use HL7.DataType,
    fields: [
      quantity: nil,
      denomination: nil
    ]
end
