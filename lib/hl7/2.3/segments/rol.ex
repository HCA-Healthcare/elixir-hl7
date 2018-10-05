defmodule HL7.V2_3.Segments.ROL do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      role_instance_id: DataTypes.Ei,
      action_code: nil,
      role: DataTypes.Ce,
      role_person: DataTypes.Xcn,
      role_begin_date_time: DataTypes.Ts,
      role_end_date_time: DataTypes.Ts,
      role_duration: DataTypes.Ce,
      role_action_assumption_reason: DataTypes.Ce
    ]
end
