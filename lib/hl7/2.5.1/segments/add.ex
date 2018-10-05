defmodule HL7.V2_5_1.Segments.ADD do
  @moduledoc false

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      addendum_continuation_pointer: nil
    ]
end
