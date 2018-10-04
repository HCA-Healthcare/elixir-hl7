defmodule HL7.V2_5_1.DataTypes.Aui do
  @moduledoc """
  The "AUI" (AUI) data type
  """

  use HL7.DataType,
    fields: [
      authorization_number: nil,
      date: nil,
      source: nil
    ]
end
