defmodule HL7.V2_3.DataTypes.Ts do
  @moduledoc false

  use HL7.DataType,
    fields: [
      time_of_an_event: nil,
      degree_of_precision: nil
    ]
end
