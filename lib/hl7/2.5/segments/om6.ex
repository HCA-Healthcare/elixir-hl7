defmodule Hl7.V2_5.Segments.OM6 do
  @moduledoc """
  HL7 segment data structure for "OM6"
  """

  require Logger

  use Hl7.Segment,
    fields: [
      segment: nil,
      sequence_number_test_observation_master_file: nil,
      derivation_rule: nil
    ]
end
