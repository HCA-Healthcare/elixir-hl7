defmodule HL7.V2_5.Segments.ERR do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			error_code_and_location: DataTypes.Eld,
			error_location: DataTypes.Erl,
			hl7_error_code: DataTypes.Cwe,
			severity: nil,
			application_error_code: DataTypes.Cwe,
			application_error_parameter: nil,
			diagnostic_information: nil,
			user_message: nil,
			inform_person_indicator: nil,
			override_type: DataTypes.Cwe,
			override_reason_code: DataTypes.Cwe,
			help_desk_contact_point: DataTypes.Xtn
    ]
end
