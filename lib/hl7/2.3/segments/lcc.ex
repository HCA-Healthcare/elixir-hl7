defmodule Hl7.V2_3.Segments.LCC do
  @moduledoc """
  HL7 segment data structure for "LCC"
  """

  require Logger
  alias Hl7.V2_3.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      primary_key_value: DataTypes.Pl,
      location_department: nil,
      accommodation_type: DataTypes.Ce,
      charge_code: DataTypes.Ce
    ]
end
