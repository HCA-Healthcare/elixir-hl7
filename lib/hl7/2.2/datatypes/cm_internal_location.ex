defmodule HL7.V2_2.DataTypes.Cminternallocation do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			nurse_unit_station: nil,
			room: nil,
			bed: nil,
			facility_id: nil,
			bed_status: nil,
			etage: nil,
			klinik: nil,
			zentrum: nil
    ]
end
