defmodule HL7.V2_3.Segments.PRB do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			action_code: nil,
			action_date_time: DataTypes.Ts,
			problem_id: DataTypes.Ce,
			problem_instance_id: DataTypes.Ei,
			episode_of_care_id: DataTypes.Ei,
			problem_list_priority: nil,
			problem_established_date_time: DataTypes.Ts,
			anticipated_problem_resolution_date_time: DataTypes.Ts,
			actual_problem_resolution_date_time: DataTypes.Ts,
			problem_classification: DataTypes.Ce,
			problem_management_discipline: DataTypes.Ce,
			problem_persistence: DataTypes.Ce,
			problem_confirmation_status: DataTypes.Ce,
			problem_life_cycle_status: DataTypes.Ce,
			problem_life_cycle_status_date_time: DataTypes.Ts,
			problem_date_of_onset: DataTypes.Ts,
			problem_onset_text: nil,
			problem_ranking: DataTypes.Ce,
			certainty_of_problem: DataTypes.Ce,
			probability_of_problem_0_1: nil,
			individual_awareness_of_problem: DataTypes.Ce,
			problem_prognosis: DataTypes.Ce,
			individual_awareness_of_prognosis: DataTypes.Ce,
			family_significant_other_awareness_of_problem_prognosis: nil,
			security_sensitivity: DataTypes.Ce
    ]
end
