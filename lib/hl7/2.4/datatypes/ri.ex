defmodule HL7.V2_4.DataTypes.Ri do
  @moduledoc """
  The "RI" (RI) data type
  """

  use HL7.DataType,
    fields: [
      repeat_pattern: nil,
      explicit_time_interval: nil
    ]
end
