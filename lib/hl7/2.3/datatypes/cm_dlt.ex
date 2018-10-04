defmodule HL7.V2_3.DataTypes.Cmdlt do
  @moduledoc """
  The "CM_DLT" (CM_DLT) data type
  """

  use HL7.DataType,
    fields: [
      range: nil,
      numeric_threshold: nil,
      change: nil,
      length_of_timedays: nil
    ]
end
