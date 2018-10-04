defmodule HL7.V2_5_1.Segments.CM2 do
  @moduledoc """
  HL7 segment data structure for "CM2"
  """

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_cm2: nil,
      scheduled_time_point: DataTypes.Ce,
      description_of_time_point: nil,
      events_scheduled_this_time_point: DataTypes.Ce
    ]
end
