defmodule HL7.V2_3.DataTypes.Cmpip do
  @moduledoc """
  The "CM_PIP" (CM_PIP) data type
  """
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
      privilege: DataTypes.Ce,
      privilege_class: DataTypes.Ce,
      expiration_date: nil,
      activation_date: nil
    ]
end
