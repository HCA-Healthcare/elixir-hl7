defmodule Hl7.V2_5.DataTypes.Wvi do
  @moduledoc """
  The "WVI" (WVI) data type
  """

  use Hl7.DataType,
    fields: [
      channel_number: nil,
      channel_name: nil
    ]
end
