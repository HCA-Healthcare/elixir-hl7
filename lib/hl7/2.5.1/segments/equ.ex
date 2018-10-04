defmodule HL7.V2_5_1.Segments.EQU do
  @moduledoc """
  HL7 segment data structure for "EQU"
  """

  require Logger
  alias HL7.V2_5_1.{DataTypes}

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
