defmodule Hl7.V2_4.DataTypes.Nr do
  @moduledoc """
  The "NR" (NR) data type
  """

  use Hl7.DataType,
    fields: [
      low_value: nil,
      high_value: nil
    ]
end
