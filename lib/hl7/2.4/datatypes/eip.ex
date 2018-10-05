defmodule HL7.V2_4.DataTypes.Eip do
  @moduledoc false
  alias HL7.V2_4.{DataTypes}

  use HL7.DataType,
    fields: [
      parents_placer_order_number: DataTypes.Ei,
      parents_filler_order_number: DataTypes.Ei
    ]
end
