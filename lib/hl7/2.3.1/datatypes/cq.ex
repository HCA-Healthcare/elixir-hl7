defmodule Hl7.V2_3_1.DataTypes.Cq do
  @moduledoc """
  The "CQ" (CQ) data type
  """
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      quantity: nil,
      units: DataTypes.Ce
    ]
end
