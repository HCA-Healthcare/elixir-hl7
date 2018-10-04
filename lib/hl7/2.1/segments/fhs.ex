defmodule HL7.V2_1.Segments.FHS do
  @moduledoc """
  HL7 segment data structure for "FHS"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      file_field_separator: nil,
      file_encoding_characters: nil,
      file_sending_application: nil,
      file_sending_facility: nil,
      file_receiving_application: nil,
      file_receiving_facility: nil,
      date_time_of_file_creation: nil,
      file_security: nil,
      file_name_id: nil,
      file_header_comment: nil,
      file_control_id: nil,
      reference_file_control_id: nil
    ]
end
