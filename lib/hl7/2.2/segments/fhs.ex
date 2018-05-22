defmodule Hl7.V2_2.Segments.FHS do
  @moduledoc """
  HL7 segment data structure for "FHS"
  """

  require Logger
  alias Hl7.V2_2.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      file_field_separator: nil,
      file_encoding_characters: nil,
      file_sending_application: nil,
      file_sending_facility: nil,
      file_receiving_application: nil,
      file_receiving_facility: nil,
      file_creation_date_time: DataTypes.Ts,
      file_security: nil,
      file_name_id: nil,
      file_header_comment: nil,
      file_control_id: nil,
      reference_file_control_id: nil
    ]
end
