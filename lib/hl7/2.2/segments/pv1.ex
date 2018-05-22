defmodule Hl7.V2_2.Segments.PV1 do
  @moduledoc """
  HL7 segment data structure for "PV1"
  """

  require Logger
  alias Hl7.V2_2.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_patient_visit: nil,
      patient_class: nil,
      assigned_patient_location: nil,
      admission_type: nil,
      preadmit_number: nil,
      prior_patient_location: nil,
      attending_doctor: nil,
      referring_doctor: nil,
      consulting_doctor: nil,
      hospital_service: nil,
      temporary_location: nil,
      preadmit_test_indicator: nil,
      readmission_indicator: nil,
      admit_source: nil,
      ambulatory_status: nil,
      vip_indicator: nil,
      admitting_doctor: nil,
      patient_type: nil,
      visit_number: nil,
      financial_class: nil,
      charge_price_indicator: nil,
      courtesy_code: nil,
      credit_rating: nil,
      contract_code: nil,
      contract_effective_date: nil,
      contract_amount: nil,
      contract_period: nil,
      interest_code: nil,
      transfer_to_bad_debt_code: nil,
      transfer_to_bad_debt_date: nil,
      bad_debt_agency_code: nil,
      bad_debt_transfer_amount: nil,
      bad_debt_recovery_amount: nil,
      delete_account_indicator: nil,
      delete_account_date: nil,
      discharge_disposition: nil,
      discharged_to_location: nil,
      diet_type: nil,
      servicing_facility: nil,
      bed_status: nil,
      account_status: nil,
      pending_location: nil,
      prior_temporary_location: nil,
      admit_date_time: DataTypes.Ts,
      discharge_date_time: DataTypes.Ts,
      current_patient_balance: nil,
      total_charges: nil,
      total_adjustments: nil,
      total_payments: nil,
      alternate_visit_id: nil
    ]
end
