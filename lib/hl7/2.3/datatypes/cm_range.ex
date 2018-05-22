defmodule Hl7.V2_3.DataTypes.Cmrange do
  @moduledoc """
  The "CM_RANGE" (CM_RANGE) data type
  """
  alias Hl7.V2_3.{DataTypes}

  use Hl7.DataType,
    fields: [
      low_value: DataTypes.Ce,
      high_value: DataTypes.Ce
    ]
end
