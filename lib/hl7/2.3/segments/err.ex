defmodule HL7.V2_3.Segments.ERR do
  @moduledoc false

  require Logger
  
  use HL7.Segment,
    fields: [
      segment: nil,
			error_code_and_location: nil
    ]
end
