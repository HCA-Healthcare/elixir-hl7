defmodule Hl7.V2_3.Segments.LOC do
  @moduledoc """
  HL7 segment data structure for "LOC"
  """

  require Logger
  alias Hl7.V2_3.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      primary_key_value: DataTypes.Pl,
      location_description: nil,
      location_type: nil,
      organization_name: DataTypes.Xon,
      location_address: DataTypes.Xad,
      location_phone: DataTypes.Xtn,
      license_number: DataTypes.Ce,
      location_equipment: nil
    ]
end
