defmodule HL7.V2_3_1.DataTypes.Aui do
  @moduledoc """
  The "AUI" (AUI) data type
  """
  alias HL7.V2_3_1.{DataTypes}

  use HL7.DataType,
    fields: [
      authorization_number: nil,
      date: DataTypes.Ts,
      source: nil
    ]
end
