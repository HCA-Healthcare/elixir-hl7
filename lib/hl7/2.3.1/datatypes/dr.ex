defmodule HL7.V2_3_1.DataTypes.Dr do
  @moduledoc false
  alias HL7.V2_3_1.{DataTypes}

  use HL7.DataType,
    fields: [
			range_start_datetime: DataTypes.Ts,
			range_end_datetime: DataTypes.Ts
    ]
end
