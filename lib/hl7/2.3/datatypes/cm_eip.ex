defmodule Hl7.V2_3.DataTypes.Cmeip do
  @moduledoc """
  The "CM_EIP" (CM_EIP) data type
  """
  alias Hl7.V2_3.{DataTypes}

  use Hl7.DataType,
    fields: [
      parents_placer_order_number: DataTypes.Ei,
      parents_filler_order_number: DataTypes.Ei
    ]
end
