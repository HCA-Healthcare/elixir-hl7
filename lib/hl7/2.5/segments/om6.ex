defmodule HL7.V2_5.Segments.OM6 do
  @moduledoc false

  require Logger
  
  use HL7.Segment,
    fields: [
      segment: nil,
			sequence_number_test_observation_master_file: nil,
			derivation_rule: nil
    ]
end
