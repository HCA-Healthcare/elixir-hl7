defmodule Hl7.V2_3.DataTypes.Pl do
  @moduledoc """
  The "PL" (PL) data type
  """
  alias Hl7.V2_3.{DataTypes}

  use Hl7.DataType,
    fields: [
      point_of_care_id: nil,
      room: nil,
      bed: nil,
      facility_hd: DataTypes.Hd,
      location_status: nil,
      person_location_type: nil,
      building: nil,
      floor: nil,
      location_type: nil
    ]
end
