defmodule HL7.V2_4.Segments.EQU do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			equipment_instance_identifier: DataTypes.Ei,
			event_date_time: DataTypes.Ts,
			equipment_state: DataTypes.Ce,
			local_remote_control_state: DataTypes.Ce,
			alert_level: DataTypes.Ce
    ]
end
