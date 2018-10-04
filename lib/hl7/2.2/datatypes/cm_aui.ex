defmodule HL7.V2_2.DataTypes.Cmaui do
  @moduledoc """
  The "CM_AUI" (CM_AUI) data type
  """

  use HL7.DataType,
    fields: [
      authorization_number: nil,
      date: nil,
      source: nil
    ]
end
