defmodule HL7.V2_3.Segments.LCC do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			primary_key_value: DataTypes.Pl,
			location_department: nil,
			accommodation_type: DataTypes.Ce,
			charge_code: DataTypes.Ce
    ]
end
