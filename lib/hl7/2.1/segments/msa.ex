defmodule Hl7.V2_1.Segments.MSA do
  @moduledoc """
  HL7 segment data structure for "MSA"
  """

  require Logger

  use Hl7.Segment,
    fields: [
      segment: nil,
      acknowledgment_code: nil,
      message_control_id: nil,
      text_message: nil,
      expected_sequence_number: nil,
      delayed_acknowledgment_type: nil
    ]
end
