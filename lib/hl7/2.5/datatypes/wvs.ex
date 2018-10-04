defmodule HL7.V2_5.DataTypes.Wvs do
  @moduledoc """
  The "WVS" (WVS) data type
  """

  use HL7.DataType,
    fields: [
      source_one_name: nil,
      source_two_name: nil
    ]
end
