defmodule HL7.V2_1.Segments.MSA do
  @moduledoc false

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      acknowledgment_code: nil,
      message_control_id: nil,
      text_message: nil,
      expected_sequence_number: nil,
      delayed_acknowledgment_type: nil
    ]
end
