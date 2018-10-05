defmodule HL7.V2_3.Segments.LCH do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			primary_key_value: DataTypes.Pl,
			segment_action_code: nil,
			segment_unique_key: DataTypes.Ei,
			location_characteristic_id: DataTypes.Ce,
			location_characteristic_value: DataTypes.Ce
    ]
end
