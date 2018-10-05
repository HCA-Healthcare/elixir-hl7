defmodule HL7.V2_4.Segments.CM2 do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_cm2: nil,
      scheduled_time_point: DataTypes.Ce,
      description_of_time_point: nil,
      events_scheduled_this_time_point: DataTypes.Ce
    ]
end
