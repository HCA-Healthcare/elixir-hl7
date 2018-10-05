defmodule HL7.V2_3.Segments.CM1 do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			cm1_set_id: nil,
			study_phase_identifier: DataTypes.Ce,
			description_of_study_phase: nil
    ]
end
