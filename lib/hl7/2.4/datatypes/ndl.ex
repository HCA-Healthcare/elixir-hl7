defmodule HL7.V2_4.DataTypes.Ndl do
  @moduledoc """
  The "NDL" (NDL) data type
  """
  alias HL7.V2_4.{DataTypes}

  use HL7.DataType,
    fields: [
      name: DataTypes.Cnn,
      start_datetime: DataTypes.Ts,
      end_datetime: DataTypes.Ts,
      point_of_care_is: nil,
      room: nil,
      bed: nil,
      facility_hd: DataTypes.Hd,
      location_status: nil,
      person_location_type: nil,
      building: nil,
      floor: nil
    ]
end
