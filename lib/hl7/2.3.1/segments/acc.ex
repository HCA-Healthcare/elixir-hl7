defmodule Hl7.V2_3_1.Segments.ACC do
  @moduledoc """
  HL7 segment data structure for "ACC"
  """

  require Logger
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.Segment,
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
