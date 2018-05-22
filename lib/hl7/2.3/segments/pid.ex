defmodule Hl7.V2_3.Segments.PID do
  @moduledoc """
  HL7 segment data structure for "PID"
  """

  require Logger
  alias Hl7.V2_3.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_patient_id: nil,
      patient_id_external_id: DataTypes.Cx,
      patient_id_internal_id: DataTypes.Cx,
      alternate_patient_id: DataTypes.Cx,
      patient_name: DataTypes.Xpn,
      mothers_maiden_name: DataTypes.Xpn,
      date_of_birth: DataTypes.Ts,
      sex: nil,
      patient_alias: DataTypes.Xpn,
      race: nil,
      patient_address: DataTypes.Xad,
      county_code: nil,
      phone_number_home: DataTypes.Xtn,
      phone_number_business: DataTypes.Xtn,
      primary_language: DataTypes.Ce,
      marital_status: nil,
      religion: nil,
      patient_account_number: DataTypes.Cx,
      ssn_number_patient: nil,
      drivers_license_number: DataTypes.Dln,
      mothers_identifier: DataTypes.Cx,
      ethnic_group: nil,
      birth_place: nil,
      multiple_birth_indicator: nil,
      birth_order: nil,
      citizenship: nil,
      veterans_military_status: DataTypes.Ce,
      nationality_code: DataTypes.Ce,
      patient_death_date_and_time: DataTypes.Ts,
      patient_death_indicator: nil
    ]
end
