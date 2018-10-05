defmodule HL7.V2_1.Segments.OBX do
  @moduledoc false

  require Logger
  alias HL7.V2_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_observation_simple: nil,
			value_type: nil,
			observation_identifier: DataTypes.Ce,
			observation_sub_id: nil,
			observation_results: nil,
			units: nil,
			references_range: nil,
			abnormal_flags: nil,
			probability: nil,
			nature_of_abnormal_test: nil,
			observ_result_status: nil,
			date_last_obs_normal_values: nil
    ]
end
