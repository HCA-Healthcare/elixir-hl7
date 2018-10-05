defmodule HL7.V2_2.DataTypes.Cmpip do
  @moduledoc false
  alias HL7.V2_2.{DataTypes}

  use HL7.DataType,
    fields: [
      privilege: DataTypes.Ce,
      privilege_class: DataTypes.Ce,
      expiration_date: nil,
      activation_date: nil
    ]
end
