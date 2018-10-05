defmodule HL7.V2_5_1.Segments.CM1 do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_cm1: nil,
			study_phase_identifier: DataTypes.Ce,
			description_of_study_phase: nil
    ]
end
