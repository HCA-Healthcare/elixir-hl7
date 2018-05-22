defmodule Hl7.V2_3_1.Segments.ADD do
  @moduledoc """
  HL7 segment data structure for "ADD"
  """

  require Logger

  use Hl7.Segment,
    fields: [
      segment: nil,
      addendum_continuation_pointer: nil
    ]
end
