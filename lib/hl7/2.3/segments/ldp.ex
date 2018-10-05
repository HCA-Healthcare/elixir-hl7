defmodule HL7.V2_3.Segments.LDP do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      ldp_primary_key_value: DataTypes.Pl,
      location_department: nil,
      location_service: nil,
      speciality_type: DataTypes.Ce,
      valid_patient_classes: nil,
      active_inactive_flag: nil,
      activation_date: DataTypes.Ts,
      inactivation_date_ldp: DataTypes.Ts,
      inactivated_reason: nil,
      visiting_hours: DataTypes.Vh,
      contact_phone: DataTypes.Xtn
    ]
end
