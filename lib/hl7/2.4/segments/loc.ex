defmodule Hl7.V2_4.Segments.LOC do
  @moduledoc """
  HL7 segment data structure for "LOC"
  """

  require Logger
  alias Hl7.V2_4.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      primary_key_value_loc: DataTypes.Pl,
      location_description: nil,
      location_type_loc: nil,
      organization_name_loc: DataTypes.Xon,
      location_address: DataTypes.Xad,
      location_phone: DataTypes.Xtn,
      license_number: DataTypes.Ce,
      location_equipment: nil,
      location_service_code: nil
    ]
end
