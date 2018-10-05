defmodule HL7.V2_3.DataTypes.Tq do
  @moduledoc false
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
			quantity: DataTypes.Cq,
			interval: nil,
			duration: nil,
			start_datetime: DataTypes.Ts,
			end_datetime: DataTypes.Ts,
			priority: nil,
			condition: nil,
			text_tx: nil,
			conjunction: nil,
			order_sequencing: nil
    ]
end
