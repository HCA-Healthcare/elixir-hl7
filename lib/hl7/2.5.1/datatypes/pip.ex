defmodule Hl7.V2_5_1.DataTypes.Pip do
  @moduledoc """
  The "PIP" (PIP) data type
  """
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      privilege: DataTypes.Ce,
      privilege_class: DataTypes.Ce,
      expiration_date: nil,
      activation_date: nil,
      facility: DataTypes.Ei
    ]
end
