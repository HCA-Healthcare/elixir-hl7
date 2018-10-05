defmodule HL7.V2_4.Segments.LRL do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			primary_key_value_lrl: DataTypes.Pl,
			segment_action_code: nil,
			segment_unique_key: DataTypes.Ei,
			location_relationship_id: DataTypes.Ce,
			organizational_location_relationship_value: DataTypes.Xon,
			patient_location_relationship_value: DataTypes.Pl
    ]
end
