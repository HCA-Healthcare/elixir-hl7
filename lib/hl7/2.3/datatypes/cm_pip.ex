defmodule Hl7.V2_3.DataTypes.Cmpip do
  @moduledoc """
  The "CM_PIP" (CM_PIP) data type
  """
  alias Hl7.V2_3.{DataTypes}

  use Hl7.DataType,
    fields: [
      privilege: DataTypes.Ce,
      privilege_class: DataTypes.Ce,
      expiration_date: nil,
      activation_date: nil
    ]
end
