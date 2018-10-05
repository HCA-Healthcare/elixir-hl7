defmodule HL7.V2_3.Segments.PD1 do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			living_dependency: nil,
			living_arrangement: nil,
			patient_primary_facility: DataTypes.Xon,
			patient_primary_care_provider_name_id_no: DataTypes.Xcn,
			student_indicator: nil,
			handicap: nil,
			living_will: nil,
			organ_donor: nil,
			separate_bill: nil,
			duplicate_patient: DataTypes.Cx,
			publicity_indicator: DataTypes.Ce,
			protection_indicator: nil
    ]
end
