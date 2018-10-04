defmodule HL7.V2_3.DataTypes.Cmwvi do
  @moduledoc """
  The "CM_WVI" (CM_WVI) data type
  """

  use HL7.DataType,
    fields: [
      channel_number: nil,
      channel_name: nil
    ]
end
