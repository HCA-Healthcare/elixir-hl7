defmodule HL7.V2_3_1.Segments.SCH do
  @moduledoc """
  HL7 segment data structure for "SCH"
  """

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      placer_appointment_id: DataTypes.Ei,
      filler_appointment_id: DataTypes.Ei,
      occurrence_number: nil,
      placer_group_number: DataTypes.Ei,
      schedule_id: DataTypes.Ce,
      event_reason: DataTypes.Ce,
      appointment_reason: DataTypes.Ce,
      appointment_type: DataTypes.Ce,
      appointment_duration: nil,
      appointment_duration_units: DataTypes.Ce,
      appointment_timing_quantity: DataTypes.Tq,
      placer_contact_person: DataTypes.Xcn,
      placer_contact_phone_number: DataTypes.Xtn,
      placer_contact_address: DataTypes.Xad,
      placer_contact_location: DataTypes.Pl,
      filler_contact_person: DataTypes.Xcn,
      filler_contact_phone_number: DataTypes.Xtn,
      filler_contact_address: DataTypes.Xad,
      filler_contact_location: DataTypes.Pl,
      entered_by_person: DataTypes.Xcn,
      entered_by_phone_number: DataTypes.Xtn,
      entered_by_location: DataTypes.Pl,
      parent_placer_appointment_id: DataTypes.Ei,
      parent_filler_appointment_id: DataTypes.Ei,
      filler_status_code: DataTypes.Ce
    ]
end
