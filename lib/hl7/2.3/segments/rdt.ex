defmodule HL7.V2_3.Segments.RDT do
  @moduledoc false

  require Logger
  
  use HL7.Segment,
    fields: [
      segment: nil,
			column_value: nil
    ]
end
