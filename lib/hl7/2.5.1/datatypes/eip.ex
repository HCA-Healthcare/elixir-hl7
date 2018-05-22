defmodule Hl7.V2_5_1.DataTypes.Eip do
  @moduledoc """
  The "EIP" (EIP) data type
  """
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      placer_assigned_identifier: DataTypes.Ei,
      filler_assigned_identifier: DataTypes.Ei
    ]
end
