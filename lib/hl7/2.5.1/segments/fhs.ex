defmodule Hl7.V2_5_1.Segments.FHS do
  @moduledoc """
  HL7 segment data structure for "FHS"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
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
