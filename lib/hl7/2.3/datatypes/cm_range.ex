defmodule HL7.V2_3.DataTypes.Cmrange do
  @moduledoc false
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
			low_value: DataTypes.Ce,
			high_value: DataTypes.Ce
    ]
end
