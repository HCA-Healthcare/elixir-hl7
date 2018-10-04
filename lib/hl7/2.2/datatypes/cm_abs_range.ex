defmodule HL7.V2_2.DataTypes.Cmabsrange do
  @moduledoc """
  The "CM_ABS_RANGE" (CM_ABS_RANGE) data type
  """

  use HL7.DataType,
    fields: [
      range: nil,
      numeric_change: nil,
      percent_per_change: nil,
      days: nil
    ]
end
