defmodule HL7.V2_2.Segments.IN1 do
  @moduledoc """
  HL7 segment data structure for "IN1"
  """

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_insurance: nil,
      insurance_plan_id: nil,
      insurance_company_id: nil,
      insurance_company_name: nil,
      insurance_company_address: DataTypes.Ad,
      insurance_company_contact_pers: DataTypes.Pn,
      insurance_company_phone_number: nil,
      group_number: nil,
      group_name: nil,
      insureds_group_employer_id: nil,
      insureds_group_employer_name: nil,
      plan_effective_date: nil,
      plan_expiration_date: nil,
      authorization_information: nil,
      plan_type: nil,
      name_of_insured: DataTypes.Pn,
      insureds_relationship_to_patient: nil,
      insureds_date_of_birth: nil,
      insureds_address: DataTypes.Ad,
      assignment_of_benefits: nil,
      coordination_of_benefits: nil,
      coordination_of_benefits_priority: nil,
      notice_of_admission_code: nil,
      notice_of_admission_date: nil,
      report_of_eligibility_code: nil,
      report_of_eligibility_date: nil,
      release_information_code: nil,
      pre_admit_certification_pac: nil,
      verification_date_time: DataTypes.Ts,
      verification_by: nil,
      type_of_agreement_code: nil,
      billing_status: nil,
      lifetime_reserve_days: nil,
      delay_before_lifetime_reserve_days: nil,
      company_plan_code: nil,
      policy_number: nil,
      policy_deductible: nil,
      policy_limit_amount: nil,
      policy_limit_days: nil,
      room_rate_semi_private: nil,
      room_rate_private: nil,
      insureds_employment_status: DataTypes.Ce,
      insureds_sex: nil,
      insureds_employer_address: DataTypes.Ad,
      verification_status: nil,
      prior_insurance_plan_id: nil
    ]
end
