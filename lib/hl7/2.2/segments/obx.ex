defmodule HL7.V2_2.Segments.OBX do
  @moduledoc """
  HL7 segment data structure for "OBX"
  """

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_observational_simple: nil,
      value_type: nil,
      observation_identifier: DataTypes.Ce,
      observation_sub_id: nil,
      observation_value: nil,
      units: DataTypes.Ce,
      references_range: nil,
      abnormal_flags: nil,
      probability: nil,
      nature_of_abnormal_test: nil,
      observation_result_status: nil,
      effective_date_last_observation_normal_values: DataTypes.Ts,
      user_defined_access_checks: nil,
      date_time_of_the_observation: DataTypes.Ts,
      producers_id: DataTypes.Ce,
      responsible_observer: nil
    ]
end
