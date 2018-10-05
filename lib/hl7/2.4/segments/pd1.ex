defmodule HL7.V2_4.Segments.PD1 do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			living_dependency: nil,
			living_arrangement: nil,
			patient_primary_facility: DataTypes.Xon,
			patient_primary_care_provider_name_id_no: DataTypes.Xcn,
			student_indicator: nil,
			handicap: nil,
			living_will_code: nil,
			organ_donor_code: nil,
			separate_bill: nil,
			duplicate_patient: DataTypes.Cx,
			publicity_code: DataTypes.Ce,
			protection_indicator: nil,
			protection_indicator_effective_date: nil,
			place_of_worship: DataTypes.Xon,
			advance_directive_code: DataTypes.Ce,
			immunization_registry_status: nil,
			immunization_registry_status_effective_date: nil,
			publicity_code_effective_date: nil,
			military_branch: nil,
			military_rank_grade: nil,
			military_status: nil
    ]
end
