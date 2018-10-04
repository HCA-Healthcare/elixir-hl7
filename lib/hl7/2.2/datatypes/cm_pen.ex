defmodule HL7.V2_2.DataTypes.Cmpen do
  @moduledoc """
  The "CM_PEN" (CM_PEN) data type
  """

  use HL7.DataType,
    fields: [
      penalty_id: nil,
      penalty_amount: nil
    ]
end
