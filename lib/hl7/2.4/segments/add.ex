defmodule HL7.V2_4.Segments.ADD do
  @moduledoc """
  HL7 segment data structure for "ADD"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      addendum_continuation_pointer: nil
    ]
end
