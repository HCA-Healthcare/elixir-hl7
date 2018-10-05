defmodule HL7.V2_3.Segments.ARQ do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			placer_appointment_id: DataTypes.Ei,
			filler_appointment_id: DataTypes.Ei,
			occurrence_number: nil,
			placer_group_number: DataTypes.Ei,
			schedule_id: DataTypes.Ce,
			request_event_reason: DataTypes.Ce,
			appointment_reason: DataTypes.Ce,
			appointment_type: DataTypes.Ce,
			appointment_duration: nil,
			appointment_duration_units: DataTypes.Ce,
			requested_start_date_time_range: DataTypes.Dr,
			priority: nil,
			repeating_interval: DataTypes.Ri,
			repeating_interval_duration: nil,
			placer_contact_person: DataTypes.Xcn,
			placer_contact_phone_number: DataTypes.Xtn,
			placer_contact_address: DataTypes.Xad,
			placer_contact_location: DataTypes.Pl,
			entered_by_person: DataTypes.Xcn,
			entered_by_phone_number: DataTypes.Xtn,
			entered_by_location: DataTypes.Pl,
			parent_placer_appointment_id: DataTypes.Ei,
			parent_filler_appointment_id: DataTypes.Ei
    ]
end
