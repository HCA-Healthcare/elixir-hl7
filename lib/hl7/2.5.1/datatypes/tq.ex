defmodule HL7.V2_5_1.DataTypes.Tq do
  @moduledoc """
  The "TQ" (TQ) data type
  """
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
      quantity: DataTypes.Cq,
      interval: DataTypes.Ri,
      duration: nil,
      start_datetime: DataTypes.Ts,
      end_datetime: DataTypes.Ts,
      priority: nil,
      condition: nil,
      text: nil,
      conjunction: nil,
      order_sequencing: DataTypes.Osd,
      occurrence_duration: DataTypes.Ce,
      total_occurrences: nil
    ]
end
