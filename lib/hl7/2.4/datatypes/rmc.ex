defmodule HL7.V2_4.DataTypes.Rmc do
  @moduledoc false

  use HL7.DataType,
    fields: [
      room_type: nil,
      amount_type: nil,
      coverage_amount: nil
    ]
end
