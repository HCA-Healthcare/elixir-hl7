defmodule Hl7.V2_5.Segments.OM5 do
  @moduledoc """
  HL7 segment data structure for "OM5"
  """

  require Logger
  alias Hl7.V2_5.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      sequence_number_test_observation_master_file: nil,
      test_observations_included_within_an_ordered_test_battery: DataTypes.Ce,
      observation_id_suffixes: nil
    ]
end
