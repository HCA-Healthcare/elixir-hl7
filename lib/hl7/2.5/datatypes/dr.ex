defmodule HL7.V2_5.DataTypes.Dr do
  @moduledoc false
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
			range_start_datetime: DataTypes.Ts,
			range_end_datetime: DataTypes.Ts
    ]
end
