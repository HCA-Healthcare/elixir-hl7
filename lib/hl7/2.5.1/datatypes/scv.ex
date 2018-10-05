defmodule HL7.V2_5_1.DataTypes.Scv do
  @moduledoc false
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
			parameter_class: DataTypes.Cwe,
			parameter_value: nil
    ]
end
