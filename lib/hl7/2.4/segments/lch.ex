defmodule Hl7.V2_4.Segments.LCH do
  @moduledoc """
  HL7 segment data structure for "LCH"
  """

  require Logger
  alias Hl7.V2_4.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      primary_key_value_lch: DataTypes.Pl,
      segment_action_code: nil,
      segment_unique_key: DataTypes.Ei,
      location_characteristic_id: DataTypes.Ce,
      location_characteristic_value_lch: DataTypes.Ce
    ]
end
