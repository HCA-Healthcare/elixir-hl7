defmodule HL7.V2_2.Segments.GT1 do
  @moduledoc false

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_guarantor: nil,
			guarantor_number: nil,
			guarantor_name: DataTypes.Pn,
			guarantor_spouse_name: DataTypes.Pn,
			guarantor_address: DataTypes.Ad,
			guarantor_phone_number_home: nil,
			guarantor_phone_number_business: nil,
			guarantor_date_of_birth: nil,
			guarantor_sex: nil,
			guarantor_type: nil,
			guarantor_relationship: nil,
			guarantor_social_security_number: nil,
			guarantor_date_begin: nil,
			guarantor_date_end: nil,
			guarantor_priority: nil,
			guarantor_employer_name: nil,
			guarantor_employer_address: DataTypes.Ad,
			guarantor_employ_phone_number: nil,
			guarantor_employee_id_number: nil,
			guarantor_employment_status: nil,
			guarantor_organization: nil
    ]
end
