defmodule HL7.V2_1.Segments.GT1 do
  @moduledoc """
  HL7 segment data structure for "GT1"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_guarantor: nil,
      guarantor_number: nil,
      guarantor_name: nil,
      guarantor_spouse_name: nil,
      guarantor_address: nil,
      guarantor_ph_num_home: nil,
      guarantor_ph_num_business: nil,
      guarantor_date_of_birth: nil,
      guarantor_sex: nil,
      guarantor_type: nil,
      guarantor_relationship: nil,
      guarantor_ssn: nil,
      guarantor_date_begin: nil,
      guarantor_date_end: nil,
      guarantor_priority: nil,
      guarantor_employer_name: nil,
      guarantor_employer_address: nil,
      guarantor_employ_phone_: nil,
      guarantor_employee_id_num: nil,
      guarantor_employment_status: nil
    ]
end
