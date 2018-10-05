defmodule HL7.V2_3.Segments.DG1 do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_diagnosis: nil,
			diagnosis_coding_method: nil,
			diagnosis_code: DataTypes.Ce,
			diagnosis_description: nil,
			diagnosis_date_time: DataTypes.Ts,
			diagnosis_type: nil,
			major_diagnostic_category: DataTypes.Ce,
			diagnostic_related_group: DataTypes.Ce,
			drg_approval_indicator: nil,
			drg_grouper_review_code: nil,
			outlier_type: DataTypes.Ce,
			outlier_days: nil,
			outlier_cost: DataTypes.Cp,
			grouper_version_and_type: nil,
			diagnosis_priority: nil,
			diagnosing_clinician: DataTypes.Xcn,
			diagnosis_classification: nil,
			confidential_indicator: nil,
			attestation_date_time: DataTypes.Ts
    ]
end
