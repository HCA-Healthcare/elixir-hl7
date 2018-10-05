defmodule HL7.V2_4.Segments.AIG do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_aig: nil,
			segment_action_code: nil,
			resource_id: DataTypes.Ce,
			resource_type: DataTypes.Ce,
			resource_group: DataTypes.Ce,
			resource_quantity: nil,
			resource_quantity_units: DataTypes.Ce,
			start_date_time: DataTypes.Ts,
			start_date_time_offset: nil,
			start_date_time_offset_units: DataTypes.Ce,
			duration: nil,
			duration_units: DataTypes.Ce,
			allow_substitution_code: nil,
			filler_status_code: DataTypes.Ce
    ]
end
