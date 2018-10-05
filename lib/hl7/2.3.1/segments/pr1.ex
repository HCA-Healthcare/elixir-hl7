defmodule HL7.V2_3_1.Segments.PR1 do
  @moduledoc false

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_pr1: nil,
      procedure_coding_method: nil,
      procedure_code: DataTypes.Ce,
      procedure_description: nil,
      procedure_date_time: DataTypes.Ts,
      procedure_functional_type: nil,
      procedure_minutes: nil,
      anesthesiologist: DataTypes.Xcn,
      anesthesia_code: nil,
      anesthesia_minutes: nil,
      surgeon: DataTypes.Xcn,
      procedure_practitioner: DataTypes.Xcn,
      consent_code: DataTypes.Ce,
      procedure_priority: nil,
      associated_diagnosis_code: DataTypes.Ce,
      procedure_code_modifier: DataTypes.Ce
    ]
end
