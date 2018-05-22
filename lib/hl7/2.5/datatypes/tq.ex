defmodule Hl7.V2_5.DataTypes.Tq do
  @moduledoc """
  The "TQ" (TQ) data type
  """
  alias Hl7.V2_5.{DataTypes}

  use Hl7.DataType,
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
