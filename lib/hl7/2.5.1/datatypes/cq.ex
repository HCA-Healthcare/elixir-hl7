defmodule HL7.V2_5_1.DataTypes.Cq do
  @moduledoc """
  The "CQ" (CQ) data type
  """
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
      quantity: nil,
      units: DataTypes.Ce
    ]
end
