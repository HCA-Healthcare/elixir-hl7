defmodule HL7.V2_5.Segments.LCH do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			primary_key_value_lch: DataTypes.Pl,
			segment_action_code: nil,
			segment_unique_key: DataTypes.Ei,
			location_characteristic_id: DataTypes.Ce,
			location_characteristic_value_lch: DataTypes.Ce
    ]
end
