defmodule HL7.V2_1.Segments.IN1 do
  @moduledoc """
  HL7 segment data structure for "IN1"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_insurance: nil,
      insurance_plan_id: nil,
      insurance_company_id: nil,
      insurance_company_name: nil,
      insurance_company_address: nil,
      insurance_co_contact_pers: nil,
      insurance_co_phone_number: nil,
      group_number: nil,
      group_name: nil,
      insureds_group_emp_id: nil,
      insureds_group_emp_name: nil,
      plan_effective_date: nil,
      plan_expiration_date: nil,
      authorization_information: nil,
      plan_type: nil,
      name_of_insured: nil,
      insureds_relationship_to_patient: nil,
      insureds_date_of_birth: nil,
      insureds_address: nil,
      assignment_of_benefits: nil,
      coordination_of_benefits: nil,
      coord_of_ben_priority: nil,
      notice_of_admission_code: nil,
      notice_of_admission_date: nil,
      rpt_of_eligibility_code: nil,
      rpt_of_eligibility_date: nil,
      release_information_code: nil,
      pre_admit_cert_pac: nil,
      verification_date: nil,
      verification_by: nil,
      type_of_agreement_code: nil,
      billing_status: nil,
      lifetime_reserve_days: nil,
      delay_before_l_r_day: nil,
      company_plan_code: nil,
      policy_number: nil,
      policy_deductible: nil,
      policy_limit_amount: nil,
      policy_limit_days: nil,
      room_rate_semi_private: nil,
      room_rate_private: nil,
      insureds_employment_status: nil,
      insureds_sex: nil,
      insureds_employer_address: nil
    ]
end
