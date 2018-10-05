defmodule HL7.V2_4.Segments.APR do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			time_selection_criteria: DataTypes.Scv,
			resource_selection_criteria: DataTypes.Scv,
			location_selection_criteria: DataTypes.Scv,
			slot_spacing_criteria: nil,
			filler_override_criteria: DataTypes.Scv
    ]
end
