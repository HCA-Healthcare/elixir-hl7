defmodule HL7.V2_2.DataTypes.Ts do
  @moduledoc """
  The "TS" (TS) data type
  """

  use HL7.DataType,
    fields: [
      time_of_an_event: nil,
      degree_of_precision: nil
    ]
end
