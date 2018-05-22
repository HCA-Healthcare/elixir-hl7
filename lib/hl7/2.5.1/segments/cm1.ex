defmodule Hl7.V2_5_1.Segments.CM1 do
  @moduledoc """
  HL7 segment data structure for "CM1"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_cm1: nil,
      study_phase_identifier: DataTypes.Ce,
      description_of_study_phase: nil
    ]
end
