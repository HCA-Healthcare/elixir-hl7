defmodule HL7.V2_2.Segments.PID do
  @moduledoc false

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_patient_id: nil,
      patient_id_external_id: nil,
      patient_id_internal_id: nil,
      alternate_patient_id: nil,
      patient_name: DataTypes.Pn,
      mothers_maiden_name: nil,
      date_of_birth: DataTypes.Ts,
      sex: nil,
      patient_alias: DataTypes.Pn,
      race: nil,
      patient_address: DataTypes.Ad,
      county_code: nil,
      phone_number_home: nil,
      phone_number_business: nil,
      language_patient: nil,
      marital_status: nil,
      religion: nil,
      patient_account_number: nil,
      social_security_number_patient: nil,
      drivers_license_number_patient: nil,
      mothers_identifier: nil,
      ethnic_group: nil,
      birth_place: nil,
      multiple_birth_indicator: nil,
      birth_order: nil,
      citizenship: nil,
      veterans_military_status: nil
    ]
end
