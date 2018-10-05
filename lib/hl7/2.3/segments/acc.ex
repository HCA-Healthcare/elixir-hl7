defmodule HL7.V2_3.Segments.ACC do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      accident_date_time: DataTypes.Ts,
      accident_code: DataTypes.Ce,
      accident_location: nil,
      auto_accident_state: DataTypes.Ce,
      accident_job_related_indicator: nil,
      accident_death_indicator: nil
    ]
end
