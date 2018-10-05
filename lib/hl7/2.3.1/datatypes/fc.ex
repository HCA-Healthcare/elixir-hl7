defmodule HL7.V2_3_1.DataTypes.Fc do
  @moduledoc false
  alias HL7.V2_3_1.{DataTypes}

  use HL7.DataType,
    fields: [
			financial_class: nil,
			effective_date: DataTypes.Ts
    ]
end
