defmodule HL7.V2_5_1.DataTypes.Ts do
  @moduledoc """
  The "TS" (TS) data type
  """

  use HL7.DataType,
    fields: [
      time: nil,
      degree_of_precision: nil
    ]
end
