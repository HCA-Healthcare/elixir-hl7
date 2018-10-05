defmodule HL7.V2_5.Segments.ROL do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			role_instance_id: DataTypes.Ei,
			action_code: nil,
			role_rol: DataTypes.Ce,
			role_person: DataTypes.Xcn,
			role_begin_date_time: DataTypes.Ts,
			role_end_date_time: DataTypes.Ts,
			role_duration: DataTypes.Ce,
			role_action_reason: DataTypes.Ce,
			provider_type: DataTypes.Ce,
			organization_unit_type: DataTypes.Ce,
			office_home_address_birthplace: DataTypes.Xad,
			phone: DataTypes.Xtn
    ]
end
