defmodule HL7.V2_4.Segments.RCP do
  @moduledoc """
  HL7 segment data structure for "RCP"
  """

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      query_priority: nil,
      quantity_limited_request: DataTypes.Cq,
      response_modality: DataTypes.Ce,
      execution_and_delivery_time: DataTypes.Ts,
      modify_indicator: nil,
      sort_by_field: DataTypes.Srt,
      segment_group_inclusion: nil
    ]
end
