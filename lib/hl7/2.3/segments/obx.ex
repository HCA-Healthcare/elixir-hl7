defmodule Hl7.V2_3.Segments.OBX do
  @moduledoc """
  HL7 segment data structure for "OBX"
  """

  require Logger
  alias Hl7.V2_3.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_obx: nil,
      value_type: nil,
      observation_identifier: DataTypes.Ce,
      observation_sub_id: nil,
      observation_value: nil,
      units: DataTypes.Ce,
      references_range: nil,
      abnormal_flags: nil,
      probability: nil,
      nature_of_abnormal_test: nil,
      observ_result_status: nil,
      date_last_obs_normal_values: DataTypes.Ts,
      user_defined_access_checks: nil,
      date_time_of_the_observation: DataTypes.Ts,
      producers_id: DataTypes.Ce,
      responsible_observer: DataTypes.Xcn,
      observation_method: DataTypes.Ce
    ]
end
