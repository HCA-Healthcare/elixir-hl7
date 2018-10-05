defmodule HL7.V2_5.Segments.DSC do
  @moduledoc false

  require Logger
  
  use HL7.Segment,
    fields: [
      segment: nil,
			continuation_pointer: nil,
			continuation_style: nil
    ]
end
