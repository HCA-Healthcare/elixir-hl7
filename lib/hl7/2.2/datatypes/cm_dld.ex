defmodule HL7.V2_2.DataTypes.Cmdld do
  @moduledoc false
  alias HL7.V2_2.{DataTypes}

  use HL7.DataType,
    fields: [
      discharge_location: nil,
      effective_date: DataTypes.Ts
    ]
end
