defmodule HL7.V2_2.DataTypes.Cmdld do
  @moduledoc """
  The "CM_DLD" (CM_DLD) data type
  """
  alias HL7.V2_2.{DataTypes}

  use HL7.DataType,
    fields: [
      discharge_location: nil,
      effective_date: DataTypes.Ts
    ]
end
