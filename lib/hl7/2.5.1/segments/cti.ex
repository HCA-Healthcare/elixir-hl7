defmodule Hl7.V2_5_1.Segments.CTI do
  @moduledoc """
  HL7 segment data structure for "CTI"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      sponsor_study_id: DataTypes.Ei,
      study_phase_identifier: DataTypes.Ce,
      study_scheduled_time_point: DataTypes.Ce
    ]
end
