defmodule Hl7.V2_4.DataTypes.Ts do
  @moduledoc """
  The "TS" (TS) data type
  """

  use Hl7.DataType,
    fields: [
      time_of_an_event: nil,
      degree_of_precision: nil
    ]
end
