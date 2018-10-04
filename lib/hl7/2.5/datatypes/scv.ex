defmodule HL7.V2_5.DataTypes.Scv do
  @moduledoc """
  The "SCV" (SCV) data type
  """
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
      parameter_class: DataTypes.Cwe,
      parameter_value: nil
    ]
end
