defmodule HL7.V2_5.Segments.CON do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_con: nil,
			consent_type: DataTypes.Cwe,
			consent_form_id: nil,
			consent_form_number: DataTypes.Ei,
			consent_text: nil,
			subject_specific_consent_text: nil,
			consent_background: nil,
			subject_specific_consent_background: nil,
			consenter_imposed_limitations: nil,
			consent_mode: DataTypes.Cne,
			consent_status: DataTypes.Cne,
			consent_discussion_date_time: DataTypes.Ts,
			consent_decision_date_time: DataTypes.Ts,
			consent_effective_date_time: DataTypes.Ts,
			consent_end_date_time: DataTypes.Ts,
			subject_competence_indicator: nil,
			translator_assistance_indicator: nil,
			language_translated_to: nil,
			informational_material_supplied_indicator: nil,
			consent_bypass_reason: DataTypes.Cwe,
			consent_disclosure_level: nil,
			consent_non_disclosure_reason: DataTypes.Cwe,
			non_subject_consenter_reason: DataTypes.Cwe,
			consenter_id: DataTypes.Xpn,
			relationship_to_subject_table: nil
    ]
end
