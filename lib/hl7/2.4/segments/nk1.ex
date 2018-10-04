defmodule HL7.V2_4.Segments.NK1 do
  @moduledoc """
  HL7 segment data structure for "NK1"
  """

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_nk1: nil,
      name: DataTypes.Xpn,
      relationship: DataTypes.Ce,
      address: DataTypes.Xad,
      phone_number: DataTypes.Xtn,
      business_phone_number: DataTypes.Xtn,
      contact_role: DataTypes.Ce,
      start_date: nil,
      end_date: nil,
      next_of_kin_associated_parties_job_title: nil,
      next_of_kin_associated_parties_job_code_class: DataTypes.Jcc,
      next_of_kin_associated_parties_employee_number: DataTypes.Cx,
      organization_name_nk1: DataTypes.Xon,
      marital_status: DataTypes.Ce,
      administrative_sex: nil,
      date_time_of_birth: DataTypes.Ts,
      living_dependency: nil,
      ambulatory_status: nil,
      citizenship: DataTypes.Ce,
      primary_language: DataTypes.Ce,
      living_arrangement: nil,
      publicity_code: DataTypes.Ce,
      protection_indicator: nil,
      student_indicator: nil,
      religion: DataTypes.Ce,
      mothers_maiden_name: DataTypes.Xpn,
      nationality: DataTypes.Ce,
      ethnic_group: DataTypes.Ce,
      contact_reason: DataTypes.Ce,
      contact_persons_name: DataTypes.Xpn,
      contact_persons_telephone_number: DataTypes.Xtn,
      contact_persons_address: DataTypes.Xad,
      next_of_kin_associated_partys_identifiers: DataTypes.Cx,
      job_status: nil,
      race: DataTypes.Ce,
      handicap: nil,
      contact_person_social_security_number: nil
    ]
end
