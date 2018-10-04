defmodule HL7.V2_3_1.Segments.LCC do
  @moduledoc """
  HL7 segment data structure for "LCC"
  """

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      primary_key_value_lcc: DataTypes.Pl,
      location_department: nil,
      accommodation_type: DataTypes.Ce,
      charge_code: DataTypes.Ce
    ]
end
