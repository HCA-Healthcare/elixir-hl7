defmodule HL7.V2_3.DataTypes.Mo do
  @moduledoc """
  The "MO" (MO) data type
  """

  use HL7.DataType,
    fields: [
      quantity: nil,
      denomination: nil
    ]
end
