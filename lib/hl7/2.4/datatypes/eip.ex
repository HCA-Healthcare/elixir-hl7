defmodule Hl7.V2_4.DataTypes.Eip do
  @moduledoc """
  The "EIP" (EIP) data type
  """
  alias Hl7.V2_4.{DataTypes}

  use Hl7.DataType,
    fields: [
      parents_placer_order_number: DataTypes.Ei,
      parents_filler_order_number: DataTypes.Ei
    ]
end
