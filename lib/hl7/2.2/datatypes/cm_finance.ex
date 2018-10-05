defmodule HL7.V2_2.DataTypes.Cmfinance do
  @moduledoc false
  alias HL7.V2_2.{DataTypes}

  use HL7.DataType,
    fields: [
			financial_class_id: nil,
			effective_date: DataTypes.Ts
    ]
end
