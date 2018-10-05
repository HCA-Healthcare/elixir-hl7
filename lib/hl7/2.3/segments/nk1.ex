defmodule HL7.V2_3.Segments.NK1 do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_next_of_kin: nil,
      name: DataTypes.Xpn,
      relationship: DataTypes.Ce,
      address: DataTypes.Xad,
      phone_number: DataTypes.Xtn,
      business_phone_number: DataTypes.Xtn,
      contact_role: DataTypes.Ce,
      start_date: nil,
      end_date: nil,
      next_of_kin_associated_parties_job_title: nil,
      next_of_kin_job_associated_parties_code_class: DataTypes.Jcc,
      next_of_kin_associated_parties_employee_number: DataTypes.Cx,
      organization_name: DataTypes.Xon,
      marital_status: nil,
      sex: nil,
      date_of_birth: DataTypes.Ts,
      living_dependency: nil,
      ambulatory_status: nil,
      citizenship: nil,
      primary_language: DataTypes.Ce,
      living_arrangement: nil,
      publicity_indicator: DataTypes.Ce,
      protection_indicator: nil,
      student_indicator: nil,
      religion: nil,
      mothers_maiden_name: DataTypes.Xpn,
      nationality_code: DataTypes.Ce,
      ethnic_group: nil,
      contact_reason: DataTypes.Ce,
      contact_persons_name: DataTypes.Xpn,
      contact_persons_telephone_number: DataTypes.Xtn,
      contact_persons_address: DataTypes.Xad,
      associated_partys_identifiers: DataTypes.Cx,
      job_status: nil,
      race: nil,
      handicap: nil,
      contact_person_social_security_number: nil
    ]
end
