defmodule Hl7.V2_3_1.Segments.OM2 do
  @moduledoc """
  HL7 segment data structure for "OM2"
  """

  require Logger
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      sequence_number_test_observation_master_file: nil,
      units_of_measure: DataTypes.Ce,
      range_of_decimal_precision: nil,
      corresponding_si_units_of_measure: DataTypes.Ce,
      si_conversion_factor: nil,
      reference_normal_range_ordinal_continuous_obs: DataTypes.Rfr,
      critical_range_for_ordinal_continuous_obs: DataTypes.Nr,
      absolute_range_for_ordinal_continuous_obs: DataTypes.Rfr,
      delta_check_criteria: DataTypes.Dlt,
      minimum_meaningful_increments: nil
    ]
end
