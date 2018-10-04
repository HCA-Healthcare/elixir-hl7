defmodule HL7.V2_3_1.DataTypes.Pip do
  @moduledoc """
  The "PIP" (PIP) data type
  """
  alias HL7.V2_3_1.{DataTypes}

  use HL7.DataType,
    fields: [
      privilege: DataTypes.Ce,
      privilege_class: DataTypes.Ce,
      expiration_date: nil,
      activation_date: nil,
      facility_ei: DataTypes.Ei
    ]
end
