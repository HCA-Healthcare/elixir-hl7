defmodule Hl7.V2_5.Segments.PV2 do
  @moduledoc """
  HL7 segment data structure for "PV2"
  """

  require Logger
  alias Hl7.V2_5.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      prior_pending_location: DataTypes.Pl,
      accommodation_code: DataTypes.Ce,
      admit_reason: DataTypes.Ce,
      transfer_reason: DataTypes.Ce,
      patient_valuables: nil,
      patient_valuables_location: nil,
      visit_user_code: nil,
      expected_admit_date_time: DataTypes.Ts,
      expected_discharge_date_time: DataTypes.Ts,
      estimated_length_of_inpatient_stay: nil,
      actual_length_of_inpatient_stay: nil,
      visit_description: nil,
      referral_source_code: DataTypes.Xcn,
      previous_service_date: nil,
      employment_illness_related_indicator: nil,
      purge_status_code: nil,
      purge_status_date: nil,
      special_program_code: nil,
      retention_indicator: nil,
      expected_number_of_insurance_plans: nil,
      visit_publicity_code: nil,
      visit_protection_indicator: nil,
      clinic_organization_name: DataTypes.Xon,
      patient_status_code: nil,
      visit_priority_code: nil,
      previous_treatment_date: nil,
      expected_discharge_disposition: nil,
      signature_on_file_date: nil,
      first_similar_illness_date: nil,
      patient_charge_adjustment_code: DataTypes.Ce,
      recurring_service_code: nil,
      billing_media_code: nil,
      expected_surgery_date_and_time: DataTypes.Ts,
      military_partnership_code: nil,
      military_non_availability_code: nil,
      newborn_baby_indicator: nil,
      baby_detained_indicator: nil,
      mode_of_arrival_code: DataTypes.Ce,
      recreational_drug_use_code: DataTypes.Ce,
      admission_level_of_care_code: DataTypes.Ce,
      precaution_code: DataTypes.Ce,
      patient_condition_code: DataTypes.Ce,
      living_will_code: nil,
      organ_donor_code: nil,
      advance_directive_code: DataTypes.Ce,
      patient_status_effective_date: nil,
      expected_loa_return_date_time: DataTypes.Ts,
      expected_pre_admission_testing_date_time: DataTypes.Ts,
      notify_clergy_code: nil
    ]
end
