defmodule HL7.V2_4.Segments.MSA do
  @moduledoc """
  HL7 segment data structure for "MSA"
  """

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      acknowledgement_code: nil,
      message_control_id: nil,
      text_message: nil,
      expected_sequence_number: nil,
      delayed_acknowledgment_type: nil,
      error_condition: DataTypes.Ce
    ]
end
