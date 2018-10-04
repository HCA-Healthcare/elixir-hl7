defmodule HL7.V2_2.DataTypes.Tq do
  @moduledoc """
  The "TQ" (TQ) data type
  """
  alias HL7.V2_2.{DataTypes}

  use HL7.DataType,
    fields: [
      quantity: nil,
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
