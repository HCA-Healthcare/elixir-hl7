defmodule HL7.V2_5_1.DataTypes.Wvi do
  @moduledoc """
  The "WVI" (WVI) data type
  """

  use HL7.DataType,
    fields: [
      channel_number: nil,
      channel_name: nil
    ]
end
