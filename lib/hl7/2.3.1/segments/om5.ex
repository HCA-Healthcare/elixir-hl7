defmodule HL7.V2_3_1.Segments.OM5 do
  @moduledoc false

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			sequence_number_test_observation_master_file: nil,
			test_observations_included_within_an_ordered_test_battery: DataTypes.Ce,
			observation_id_suffixes: nil
    ]
end
