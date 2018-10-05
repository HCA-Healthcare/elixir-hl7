defmodule HL7.V2_4.Segments.OM3 do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			sequence_number_test_observation_master_file: nil,
			preferred_coding_system: DataTypes.Ce,
			valid_coded_answers_: DataTypes.Ce,
			normal_text_codes_for_categorical_observations: DataTypes.Ce,
			abnormal_text_codes_for_categorical_observations: DataTypes.Ce,
			critical_text_codes_for_categorical_observations: DataTypes.Ce,
			value_type: nil
    ]
end
