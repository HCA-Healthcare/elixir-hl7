defmodule HL7.V2_1.Segments.PID do
  @moduledoc false

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_patient_id: nil,
      patient_id_external_external_id: nil,
      patient_id_internal_internal_id: nil,
      alternate_patient_id: nil,
      patient_name: nil,
      mothers_maiden_name: nil,
      date_of_birth: nil,
      sex: nil,
      patient_alias: nil,
      ethnic_group: nil,
      patient_address: nil,
      county_code: nil,
      phone_number_home: nil,
      phone_number_business: nil,
      language_patient: nil,
      marital_status: nil,
      religion: nil,
      patient_account_number: nil,
      ssn_number_patient: nil,
      drivers_lic_num_patient: nil
    ]
end
