defmodule Hl7.V2_5_1.Segments.MSH do
  @moduledoc """
  HL7 segment data structure for "MSH"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      field_separator: nil,
      encoding_characters: nil,
      sending_application: DataTypes.Hd,
      sending_facility: DataTypes.Hd,
      receiving_application: DataTypes.Hd,
      receiving_facility: DataTypes.Hd,
      date_time_of_message: DataTypes.Ts,
      security: nil,
      message_type: DataTypes.Msg,
      message_control_id: nil,
      processing_id: DataTypes.Pt,
      version_id: DataTypes.Vid,
      sequence_number: nil,
      continuation_pointer: nil,
      accept_acknowledgment_type: nil,
      application_acknowledgment_type: nil,
      country_code: nil,
      character_set: nil,
      principal_language_of_message: DataTypes.Ce,
      alternate_character_set_handling_scheme: nil,
      message_profile_identifier: DataTypes.Ei
    ]
end
