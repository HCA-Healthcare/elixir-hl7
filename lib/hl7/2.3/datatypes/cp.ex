defmodule HL7.V2_3.DataTypes.Cp do
  @moduledoc false
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
			price: DataTypes.Mo,
			price_type: nil,
			from_value: nil,
			to_value: nil,
			range_units: DataTypes.Ce,
			range_type: nil
    ]
end
