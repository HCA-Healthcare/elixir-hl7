defmodule HL7.V2_2.Segments.OM3 do
  @moduledoc """
  HL7 segment data structure for "OM3"
  """

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      segment_type_id: nil,
      sequence_number_test_observation_master_file: nil,
      preferred_coding_system: nil,
      valid_coded_answers: DataTypes.Ce,
      normal_test_codes_for_categorical_observations: DataTypes.Ce,
      abnormal_test_codes_for_categorical_observations: DataTypes.Ce,
      critical_test_codes_for_categorical_observations: DataTypes.Ce,
      data_type: nil
    ]
end
