defmodule HL7.V2_4.Segments.PID do
  @moduledoc """
  HL7 segment data structure for "PID"
  """

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_pid: nil,
      patient_id: DataTypes.Cx,
      patient_identifier_list: DataTypes.Cx,
      alternate_patient_id_pid: DataTypes.Cx,
      patient_name: DataTypes.Xpn,
      mothers_maiden_name: DataTypes.Xpn,
      date_time_of_birth: DataTypes.Ts,
      administrative_sex: nil,
      patient_alias: DataTypes.Xpn,
      race: DataTypes.Ce,
      patient_address: DataTypes.Xad,
      county_code: nil,
      phone_number_home: DataTypes.Xtn,
      phone_number_business: DataTypes.Xtn,
      primary_language: DataTypes.Ce,
      marital_status: DataTypes.Ce,
      religion: DataTypes.Ce,
      patient_account_number: DataTypes.Cx,
      ssn_number_patient: nil,
      drivers_license_number_patient: DataTypes.Dln,
      mothers_identifier: DataTypes.Cx,
      ethnic_group: DataTypes.Ce,
      birth_place: nil,
      multiple_birth_indicator: nil,
      birth_order: nil,
      citizenship: DataTypes.Ce,
      veterans_military_status: DataTypes.Ce,
      nationality: DataTypes.Ce,
      patient_death_date_and_time: DataTypes.Ts,
      patient_death_indicator: nil,
      identity_unknown_indicator: nil,
      identity_reliability_code: nil,
      last_update_date_time: DataTypes.Ts,
      last_update_facility: DataTypes.Hd,
      species_code: DataTypes.Ce,
      breed_code: DataTypes.Ce,
      strain: nil,
      production_class_code: DataTypes.Ce
    ]
end
