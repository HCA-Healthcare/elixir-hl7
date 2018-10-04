defmodule HL7.V2_5_1.Segments.LCH do
  @moduledoc """
  HL7 segment data structure for "LCH"
  """

  require Logger
  alias HL7.V2_5_1.{DataTypes}

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
