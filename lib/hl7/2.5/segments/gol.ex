defmodule HL7.V2_5.Segments.GOL do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			action_code: nil,
			action_date_time: DataTypes.Ts,
			goal_id: DataTypes.Ce,
			goal_instance_id: DataTypes.Ei,
			episode_of_care_id: DataTypes.Ei,
			goal_list_priority: nil,
			goal_established_date_time: DataTypes.Ts,
			expected_goal_achieve_date_time: DataTypes.Ts,
			goal_classification: DataTypes.Ce,
			goal_management_discipline: DataTypes.Ce,
			current_goal_review_status: DataTypes.Ce,
			current_goal_review_date_time: DataTypes.Ts,
			next_goal_review_date_time: DataTypes.Ts,
			previous_goal_review_date_time: DataTypes.Ts,
			goal_review_interval: DataTypes.Tq,
			goal_evaluation: DataTypes.Ce,
			goal_evaluation_comment: nil,
			goal_life_cycle_status: DataTypes.Ce,
			goal_life_cycle_status_date_time: DataTypes.Ts,
			goal_target_type: DataTypes.Ce,
			goal_target_name: DataTypes.Xpn
    ]
end
