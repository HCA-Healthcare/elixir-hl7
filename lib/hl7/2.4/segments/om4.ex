defmodule HL7.V2_4.Segments.OM4 do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			sequence_number_test_observation_master_file: nil,
			derived_specimen: nil,
			container_description: nil,
			container_volume: nil,
			container_units: DataTypes.Ce,
			specimen: DataTypes.Ce,
			additive: DataTypes.Ce,
			preparation: nil,
			special_handling_requirements: nil,
			normal_collection_volume: DataTypes.Cq,
			minimum_collection_volume: DataTypes.Cq,
			specimen_requirements: nil,
			specimen_priorities: nil,
			specimen_retention_time: DataTypes.Cq
    ]
end
