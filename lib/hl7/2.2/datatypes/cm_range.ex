defmodule HL7.V2_2.DataTypes.Cmrange do
  @moduledoc false
  alias HL7.V2_2.{DataTypes}

  use HL7.DataType,
    fields: [
			low_value: DataTypes.Ce,
			high_value: DataTypes.Ce
    ]
end
