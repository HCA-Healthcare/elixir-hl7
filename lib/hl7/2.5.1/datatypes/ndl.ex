defmodule HL7.V2_5_1.DataTypes.Ndl do
  @moduledoc false
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
			name: DataTypes.Cnn,
			start_datetime: DataTypes.Ts,
			end_datetime: DataTypes.Ts,
			point_of_care: nil,
			room: nil,
			bed: nil,
			facility: DataTypes.Hd,
			location_status: nil,
			patient_location_type: nil,
			building: nil,
			floor: nil
    ]
end
