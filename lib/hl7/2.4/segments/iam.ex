defmodule Hl7.V2_4.Segments.IAM do
  @moduledoc """
  HL7 segment data structure for "IAM"
  """

  require Logger
  alias Hl7.V2_4.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_iam: nil,
      allergen_type_code: DataTypes.Ce,
      allergen_code_mnemonic_description: DataTypes.Ce,
      allergy_severity_code: DataTypes.Ce,
      allergy_reaction_code: nil,
      allergy_action_code: DataTypes.Cne,
      allergy_unique_identifier: DataTypes.Ei,
      action_reason: nil,
      sensitivity_to_causative_agent_code: DataTypes.Ce,
      allergen_group_code_mnemonic_description: DataTypes.Ce,
      onset_date: nil,
      onset_date_text: nil,
      reported_date_time: DataTypes.Ts,
      reported_by: DataTypes.Xpn,
      relationship_to_patient_code: DataTypes.Ce,
      alert_device_code: DataTypes.Ce,
      allergy_clinical_status_code: DataTypes.Ce,
      statused_by_person: DataTypes.Xcn,
      statused_by_organization: DataTypes.Xon,
      statused_at_date_time: DataTypes.Ts
    ]
end
