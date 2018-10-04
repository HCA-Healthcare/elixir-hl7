defmodule HL7.V2_2.Segments.OM6 do
  @moduledoc """
  HL7 segment data structure for "OM6"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      segment_type_id: nil,
      sequence_number_test_observation_master_file: nil,
      derivation_rule: nil
    ]
end
