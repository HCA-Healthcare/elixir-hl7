defmodule Hl7.V2_3.Segments.STF do
  @moduledoc """
  HL7 segment data structure for "STF"
  """

  require Logger
  alias Hl7.V2_3.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      stf_primary_key_value: DataTypes.Ce,
      staff_id_code: DataTypes.Ce,
      staff_name: DataTypes.Xpn,
      staff_type: nil,
      sex: nil,
      date_of_birth: DataTypes.Ts,
      active_inactive_flag: nil,
      department: DataTypes.Ce,
      service: DataTypes.Ce,
      phone: nil,
      office_home_address: DataTypes.Ad,
      activation_date: nil,
      inactivation_date: nil,
      backup_person_id: DataTypes.Ce,
      e_mail_address: nil,
      preferred_method_of_contact: DataTypes.Ce,
      marital_status: nil,
      job_title: nil,
      job_code_class: DataTypes.Jcc,
      employment_status: nil,
      additional_insured_on_auto: nil,
      drivers_license_number: DataTypes.Dln,
      copy_auto_ins: nil,
      auto_ins_expires: nil,
      date_last_dmv_review: nil,
      date_next_dmv_review: nil
    ]
end
