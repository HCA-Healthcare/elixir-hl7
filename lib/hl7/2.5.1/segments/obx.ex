defmodule HL7.V2_5_1.Segments.OBX do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_obx: nil,
			value_type: nil,
			observation_identifier: DataTypes.Ce,
			observation_sub_id: nil,
			observation_value: nil,
			units: DataTypes.Ce,
			references_range: nil,
			abnormal_flags: nil,
			probability: nil,
			nature_of_abnormal_test: nil,
			observation_result_status: nil,
			effective_date_of_reference_range_values: DataTypes.Ts,
			user_defined_access_checks: nil,
			date_time_of_the_observation: DataTypes.Ts,
			producers_reference: DataTypes.Ce,
			responsible_observer: DataTypes.Xcn,
			observation_method: DataTypes.Ce,
			equipment_instance_identifier: DataTypes.Ei,
			date_time_of_the_analysis: DataTypes.Ts,
			performing_organization_name: DataTypes.Xon,
			performing_organization_address: DataTypes.Xad,
			performing_organization_medical_director: DataTypes.Xcn
    ]
end
