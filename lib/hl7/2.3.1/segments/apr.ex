defmodule Hl7.V2_3_1.Segments.APR do
  @moduledoc """
  HL7 segment data structure for "APR"
  """

  require Logger
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      time_selection_criteria: DataTypes.Scv,
      resource_selection_criteria: DataTypes.Scv,
      location_selection_criteria: DataTypes.Scv,
      slot_spacing_criteria: nil,
      filler_override_criteria: DataTypes.Scv
    ]
end
