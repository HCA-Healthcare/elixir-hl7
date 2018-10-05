defmodule HL7.V2_3_1.Segments.PID do
  @moduledoc false

  require Logger
  alias HL7.V2_3_1.{DataTypes}

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
			sex: nil,
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
			patient_death_indicator: nil
    ]
end
