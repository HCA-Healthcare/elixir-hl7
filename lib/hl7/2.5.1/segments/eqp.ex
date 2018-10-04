defmodule HL7.V2_5_1.Segments.EQP do
  @moduledoc """
  HL7 segment data structure for "EQP"
  """

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      event_type: DataTypes.Ce,
      file_name: nil,
      start_date_time: DataTypes.Ts,
      end_date_time: DataTypes.Ts,
      transaction_data: nil
    ]
end
