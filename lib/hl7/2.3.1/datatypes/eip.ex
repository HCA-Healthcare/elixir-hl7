defmodule HL7.V2_3_1.DataTypes.Eip do
  @moduledoc """
  The "EIP" (EIP) data type
  """
  alias HL7.V2_3_1.{DataTypes}

  use HL7.DataType,
    fields: [
      parents_placer_order_number: DataTypes.Ei,
      parents_filler_order_number: DataTypes.Ei
    ]
end
