defmodule HL7.V2_5.DataTypes.Rmc do
  @moduledoc false
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
			room_type: nil,
			amount_type: nil,
			coverage_amount: nil,
			money_or_percentage: DataTypes.Mop
    ]
end
