defmodule HL7.V2_4.DataTypes.Scv do
  @moduledoc """
  The "SCV" (SCV) data type
  """

  use HL7.DataType,
    fields: [
      parameter_class: nil,
      parameter_value: nil
    ]
end
