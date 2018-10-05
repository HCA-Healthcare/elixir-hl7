defmodule HL7.V2_2.Segments.PR1 do
  @moduledoc false

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_procedure: nil,
			procedure_coding_method: nil,
			procedure_code: nil,
			procedure_description: nil,
			procedure_date_time: DataTypes.Ts,
			procedure_type: nil,
			procedure_minutes: nil,
			anesthesiologist: nil,
			anesthesia_code: nil,
			anesthesia_minutes: nil,
			surgeon: nil,
			procedure_practitioner: nil,
			consent_code: nil,
			procedure_priority: nil
    ]
end
