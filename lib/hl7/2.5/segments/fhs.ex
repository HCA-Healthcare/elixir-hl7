defmodule HL7.V2_5.Segments.FHS do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			file_field_separator: nil,
			file_encoding_characters: nil,
			file_sending_application: DataTypes.Hd,
			file_sending_facility: DataTypes.Hd,
			file_receiving_application: DataTypes.Hd,
			file_receiving_facility: DataTypes.Hd,
			file_creation_date_time: DataTypes.Ts,
			file_security: nil,
			file_name_id: nil,
			file_header_comment: nil,
			file_control_id: nil,
			reference_file_control_id: nil
    ]
end
