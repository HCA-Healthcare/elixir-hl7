defmodule Hl7.V2_5_1.Segments.LDP do
  @moduledoc """
  HL7 segment data structure for "LDP"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      primary_key_value_ldp: DataTypes.Pl,
      location_department: DataTypes.Ce,
      location_service: nil,
      specialty_type: DataTypes.Ce,
      valid_patient_classes: nil,
      active_inactive_flag: nil,
      activation_date_ldp: DataTypes.Ts,
      inactivation_date_ldp: DataTypes.Ts,
      inactivated_reason: nil,
      visiting_hours: DataTypes.Vh,
      contact_phone: DataTypes.Xtn,
      location_cost_center: DataTypes.Ce
    ]
end
