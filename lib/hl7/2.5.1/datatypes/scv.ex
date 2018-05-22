defmodule Hl7.V2_5_1.DataTypes.Scv do
  @moduledoc """
  The "SCV" (SCV) data type
  """
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      parameter_class: DataTypes.Cwe,
      parameter_value: nil
    ]
end
