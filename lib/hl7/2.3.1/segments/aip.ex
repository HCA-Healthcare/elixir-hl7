defmodule HL7.V2_3_1.Segments.AIP do
  @moduledoc false

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_aip: nil,
			segment_action_code: nil,
			personnel_resource_id: DataTypes.Xcn,
			resource_role: DataTypes.Ce,
			resource_group: DataTypes.Ce,
			start_date_time: DataTypes.Ts,
			start_date_time_offset: nil,
			start_date_time_offset_units: DataTypes.Ce,
			duration: nil,
			duration_units: DataTypes.Ce,
			allow_substitution_code: nil,
			filler_status_code: DataTypes.Ce
    ]
end
