defmodule HL7.V2_3.DataTypes.Cmeip do
  @moduledoc false
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
			parents_placer_order_number: DataTypes.Ei,
			parents_filler_order_number: DataTypes.Ei
    ]
end
