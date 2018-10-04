defmodule HL7.V2_2.Segments.OM4 do
  @moduledoc """
  HL7 segment data structure for "OM4"
  """

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      segment_type_id: nil,
      sequence_number_test_observation_master_file: nil,
      derived_specimen: nil,
      container_description: nil,
      container_volume: nil,
      container_units: DataTypes.Ce,
      specimen: DataTypes.Ce,
      additive: DataTypes.Ce,
      preparation: nil,
      special_handling_requirements: nil,
      normal_collection_volume: nil,
      minimum_collection_volume: nil,
      specimen_requirements: nil,
      specimen_priorities: nil,
      specimen_retention_time: nil
    ]
end
