defmodule HL7.V2_3.Segments.OM2 do
  @moduledoc """
  HL7 segment data structure for "OM2"
  """

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      sequence_number_test_observation_master_file: nil,
      units_of_measure: DataTypes.Ce,
      range_of_decimal_precision: nil,
      corresponding_si_units_of_measure: DataTypes.Ce,
      si_conversion_factor: nil,
      reference_normal_range_ordinal_continuous_obs: nil,
      critical_range_for_ordinal_continuous_obs: nil,
      absolute_range_for_ordinal_continuous_obs: nil,
      delta_check_criteria: nil,
      minimum_meaningful_increments: nil
    ]
end
