defmodule HL7.V2_2.Segments.IN3 do
  @moduledoc false

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_insurance_certification: nil,
			certification_number: nil,
			certified_by: nil,
			certification_required: nil,
			penalty: nil,
			certification_date_time: DataTypes.Ts,
			certification_modify_date_time: DataTypes.Ts,
			operator: nil,
			certification_begin_date: nil,
			certification_end_date: nil,
			days: nil,
			non_concur_code_description: DataTypes.Ce,
			non_concur_effective_date_time: DataTypes.Ts,
			physician_reviewer: nil,
			certification_contact: nil,
			certification_contact_phone_number: nil,
			appeal_reason: DataTypes.Ce,
			certification_agency: DataTypes.Ce,
			certification_agency_phone_number: nil,
			pre_certification_required_window: nil,
			case_manager: nil,
			second_opinion_date: nil,
			second_opinion_status: nil,
			second_opinion_documentation_received: nil,
			second_opinion_practitioner: nil
    ]
end
