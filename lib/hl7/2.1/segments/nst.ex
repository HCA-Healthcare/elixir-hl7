defmodule HL7.V2_1.Segments.NST do
  @moduledoc false

  require Logger
  
  use HL7.Segment,
    fields: [
      segment: nil,
			statistics_available: nil,
			source_identifier: nil,
			source_type: nil,
			statistics_start: nil,
			statistics_end: nil,
			receive_character_count: nil,
			send_character_count: nil,
			messages_received: nil,
			messages_sent: nil,
			checksum_errors_received: nil,
			length_errors_received: nil,
			other_errors_received: nil,
			connect_timeouts: nil,
			receive_timeouts: nil,
			network_errors: nil
    ]
end
