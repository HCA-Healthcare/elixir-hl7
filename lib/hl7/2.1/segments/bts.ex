defmodule HL7.V2_1.Segments.BTS do
  @moduledoc false

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      batch_message_count: nil,
      batch_comment: nil,
      batch_totals: nil
    ]
end
