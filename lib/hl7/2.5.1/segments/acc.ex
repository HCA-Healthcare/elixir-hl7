defmodule HL7.V2_5_1.Segments.ACC do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      accident_date_time: DataTypes.Ts,
      accident_code: DataTypes.Ce,
      accident_location: nil,
      auto_accident_state: DataTypes.Ce,
      accident_job_related_indicator: nil,
      accident_death_indicator: nil,
      entered_by: DataTypes.Xcn,
      accident_description: nil,
      brought_in_by: nil,
      police_notified_indicator: nil,
      accident_address: DataTypes.Xad
    ]
end
