defmodule HL7.V2_2.Segments.DG1 do
  @moduledoc false

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_diagnosis: nil,
			diagnosis_coding_method: nil,
			diagnosis_code: nil,
			diagnosis_description: nil,
			diagnosis_date_time: DataTypes.Ts,
			diagnosis_drg_type: nil,
			major_diagnostic_category: DataTypes.Ce,
			diagnostic_related_group: nil,
			drg_approval_indicator: nil,
			drg_grouper_review_code: nil,
			outlier_type: nil,
			outlier_days: nil,
			outlier_cost: nil,
			grouper_version_and_type: nil,
			diagnosis_drg_priority: nil,
			diagnosing_clinician: nil
    ]
end
