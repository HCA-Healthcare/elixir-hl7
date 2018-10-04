defmodule HL7.V2_2.Segments.NST do
  @moduledoc """
  HL7 segment data structure for "NST"
  """

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      statistics_available: nil,
      source_identifier: nil,
      source_type: nil,
      statistics_start: DataTypes.Ts,
      statistics_end: DataTypes.Ts,
      receive_character_count: nil,
      send_character_count: nil,
      message_received: nil,
      message_sent: nil,
      checksum_errors_received: nil,
      length_errors_received: nil,
      other_errors_received: nil,
      connect_timeouts: nil,
      receive_timeouts: nil,
      network_errors: nil
    ]
end
