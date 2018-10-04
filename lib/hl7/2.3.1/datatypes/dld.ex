defmodule HL7.V2_3_1.DataTypes.Dld do
  @moduledoc """
  The "DLD" (DLD) data type
  """
  alias HL7.V2_3_1.{DataTypes}

  use HL7.DataType,
    fields: [
      discharge_location: nil,
      effective_date: DataTypes.Ts
    ]
end
