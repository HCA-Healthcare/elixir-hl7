defmodule HL7.V2_3.DataTypes.Cmaui do
  @moduledoc """
  The "CM_AUI" (CM_AUI) data type
  """
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
      authorization_number: nil,
      date: DataTypes.Ts,
      source: nil
    ]
end
