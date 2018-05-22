defmodule Hl7.V2_5_1.DataTypes.Dld do
  @moduledoc """
  The "DLD" (DLD) data type
  """
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      discharge_location: nil,
      effective_date: DataTypes.Ts
    ]
end
