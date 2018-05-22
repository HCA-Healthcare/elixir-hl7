defmodule Hl7.V2_2.DataTypes.Cmdld do
  @moduledoc """
  The "CM_DLD" (CM_DLD) data type
  """
  alias Hl7.V2_2.{DataTypes}

  use Hl7.DataType,
    fields: [
      discharge_location: nil,
      effective_date: DataTypes.Ts
    ]
end
