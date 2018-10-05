defmodule HL7.V2_5_1.DataTypes.Dld do
  @moduledoc false
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
			discharge_location: nil,
			effective_date: DataTypes.Ts
    ]
end
