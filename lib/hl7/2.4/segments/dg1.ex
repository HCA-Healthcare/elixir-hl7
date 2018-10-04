defmodule HL7.V2_4.Segments.DG1 do
  @moduledoc """
  HL7 segment data structure for "DG1"
  """

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_dg1: nil,
      diagnosis_coding_method: nil,
      diagnosis_code_dg1: DataTypes.Ce,
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
