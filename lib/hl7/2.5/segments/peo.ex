defmodule HL7.V2_5.Segments.PEO do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			event_identifiers_used: DataTypes.Ce,
			event_symptom_diagnosis_code: DataTypes.Ce,
			event_onset_date_time: DataTypes.Ts,
			event_exacerbation_date_time: DataTypes.Ts,
			event_improved_date_time: DataTypes.Ts,
			event_ended_data_time: DataTypes.Ts,
			event_location_occurred_address: DataTypes.Xad,
			event_qualification: nil,
			event_serious: nil,
			event_expected: nil,
			event_outcome: nil,
			patient_outcome: nil,
			event_description_from_others: nil,
			event_from_original_reporter: nil,
			event_description_from_patient: nil,
			event_description_from_practitioner: nil,
			event_description_from_autopsy: nil,
			cause_of_death: DataTypes.Ce,
			primary_observer_name: DataTypes.Xpn,
			primary_observer_address: DataTypes.Xad,
			primary_observer_telephone: DataTypes.Xtn,
			primary_observers_qualification: nil,
			confirmation_provided_by: nil,
			primary_observer_aware_date_time: DataTypes.Ts,
			primary_observers_identity_may_be_divulged: nil
    ]
end
