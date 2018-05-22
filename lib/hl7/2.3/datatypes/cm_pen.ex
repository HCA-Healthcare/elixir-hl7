defmodule Hl7.V2_3.DataTypes.Cmpen do
  @moduledoc """
  The "CM_PEN" (CM_PEN) data type
  """

  use Hl7.DataType,
    fields: [
      penalty_type: nil,
      penalty_amount: nil
    ]
end
