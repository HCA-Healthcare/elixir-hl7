defmodule HL7.V2_2.Segments.STF do
  @moduledoc false

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			stf_primary_key_value: DataTypes.Ce,
			staff_id_code: DataTypes.Ce,
			staff_name: DataTypes.Pn,
			staff_type: nil,
			sex: nil,
			date_of_birth: DataTypes.Ts,
			active_inactive: nil,
			department: DataTypes.Ce,
			service: DataTypes.Ce,
			phone: nil,
			office_home_address: DataTypes.Ad,
			activation_date: nil,
			inactivation_date: nil,
			backup_person_id: DataTypes.Ce,
			e_mail_address: nil,
			preferred_method_of_contact: nil
    ]
end
