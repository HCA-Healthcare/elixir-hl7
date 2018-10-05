defmodule HL7.V2_2.Segments.OM2 do
  @moduledoc false

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      segment_type_id: nil,
      sequence_number_test_observation_master_file: nil,
      units_of_measure: DataTypes.Ce,
      range_of_decimal_precision: nil,
      corresponding_si_units_of_measure: DataTypes.Ce,
      si_conversion_factor: nil,
      reference_normal_range_ordinal_continuous_observations: nil,
      critical_range_for_ordinal_and_continuous_observations: nil,
      absolute_range_for_ordinal_and_continuous_observations: nil,
      delta_check_criteria: nil,
      minimum_meaningful_increments: nil
    ]
end
