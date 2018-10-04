defmodule HL7.V2_3_1.Segments.CSP do
  @moduledoc """
  HL7 segment data structure for "CSP"
  """

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      study_phase_identifier: DataTypes.Ce,
      date_time_study_phase_began: DataTypes.Ts,
      date_time_study_phase_ended: DataTypes.Ts,
      study_phase_evaluability: DataTypes.Ce
    ]
end
