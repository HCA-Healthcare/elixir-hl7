defmodule HL7.V2_5.DataTypes.Eip do
  @moduledoc """
  The "EIP" (EIP) data type
  """
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
      placer_assigned_identifier: DataTypes.Ei,
      filler_assigned_identifier: DataTypes.Ei
    ]
end
