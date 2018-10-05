defmodule HL7.V2_5.DataTypes.Pip do
  @moduledoc false
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
      privilege: DataTypes.Ce,
      privilege_class: DataTypes.Ce,
      expiration_date: nil,
      activation_date: nil,
      facility: DataTypes.Ei
    ]
end
