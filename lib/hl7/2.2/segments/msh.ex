defmodule Hl7.V2_2.Segments.MSH do
  @moduledoc """
  HL7 segment data structure for "MSH"
  """

  require Logger
  alias Hl7.V2_2.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      field_separator: nil,
      encoding_characters: nil,
      sending_application: nil,
      sending_facility: nil,
      receiving_application: nil,
      receiving_facility: nil,
      date_time_of_message: DataTypes.Ts,
      security: nil,
      message_type: nil,
      message_control_id: nil,
      processing_id: nil,
      version_id: nil,
      sequence_number: nil,
      continuation_pointer: nil,
      accept_acknowledgement_type: nil,
      application_acknowledgement_type: nil,
      country_code: nil
    ]
end
