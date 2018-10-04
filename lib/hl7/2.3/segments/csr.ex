defmodule HL7.V2_3.Segments.CSR do
  @moduledoc """
  HL7 segment data structure for "CSR"
  """

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      sponsor_study_id: DataTypes.Ei,
      alternate_study_id: DataTypes.Ei,
      institution_registering_the_patient: DataTypes.Ce,
      sponsor_patient_id: DataTypes.Cx,
      alternate_patient_id: DataTypes.Cx,
      date_time_of_patient_study_registration: DataTypes.Ts,
      person_performing_study_registration: DataTypes.Xcn,
      study_authorizing_provider: DataTypes.Xcn,
      date_time_patient_study_consent_signed: DataTypes.Ts,
      patient_study_eligibility_status: DataTypes.Ce,
      study_randomization_date_time: DataTypes.Ts,
      study_randomized_arm: DataTypes.Ce,
      stratum_for_study_randomization: DataTypes.Ce,
      patient_evaluability_status: DataTypes.Ce,
      date_time_ended_study: DataTypes.Ts,
      reason_ended_study: DataTypes.Ce
    ]
end
