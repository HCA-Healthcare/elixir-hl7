defmodule HL7.V2_2.Segments.IN2 do
  @moduledoc false

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			insureds_employee_id: nil,
			insureds_social_security_number: nil,
			insureds_employer_name: nil,
			employer_information_data: nil,
			mail_claim_party: nil,
			medicare_health_insurance_card_number: nil,
			medicaid_case_name: DataTypes.Pn,
			medicaid_case_number: nil,
			champus_sponsor_name: DataTypes.Pn,
			champus_id_number: nil,
			dependent_of_champus_recipient: nil,
			champus_organization: nil,
			champus_station: nil,
			champus_service: nil,
			champus_rank_grade: nil,
			champus_status: nil,
			champus_retire_date: nil,
			champus_non_availability_certification_on_file: nil,
			baby_coverage: nil,
			combine_baby_bill: nil,
			blood_deductible: nil,
			special_coverage_approval_name: DataTypes.Pn,
			special_coverage_approval_title: nil,
			non_covered_insurance_code: nil,
			payor_id: nil,
			payor_subscriber_id: nil,
			eligibility_source: nil,
			room_coverage_type_amount: nil,
			policy_type_amount: nil,
			daily_deductible: nil
    ]
end
