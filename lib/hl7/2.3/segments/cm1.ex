defmodule Hl7.V2_3.Segments.CM1 do
  @moduledoc """
  HL7 segment data structure for "CM1"
  """

  require Logger
  alias Hl7.V2_3.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      cm1_set_id: nil,
      study_phase_identifier: DataTypes.Ce,
      description_of_study_phase: nil
    ]
end
