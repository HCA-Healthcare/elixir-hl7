defmodule HL7.V2_3_1.DataTypes.Sn do
  @moduledoc """
  The "SN" (SN) data type
  """

  use HL7.DataType,
    fields: [
      comparator: nil,
      num1: nil,
      separator_or_suffix: nil,
      num2: nil
    ]
end
