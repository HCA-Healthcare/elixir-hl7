defmodule HL7.V2_4.Segments.CTI do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      sponsor_study_id: DataTypes.Ei,
      study_phase_identifier: DataTypes.Ce,
      study_scheduled_time_point: DataTypes.Ce
    ]
end
