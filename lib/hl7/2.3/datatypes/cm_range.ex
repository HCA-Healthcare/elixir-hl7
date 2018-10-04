defmodule HL7.V2_3.DataTypes.Cmrange do
  @moduledoc """
  The "CM_RANGE" (CM_RANGE) data type
  """
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
      low_value: DataTypes.Ce,
      high_value: DataTypes.Ce
    ]
end
