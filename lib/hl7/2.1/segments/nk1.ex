defmodule HL7.V2_1.Segments.NK1 do
  @moduledoc false

  require Logger
  
  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_next_of_kin: nil,
			next_of_kin_name: nil,
			next_of_kin_relationship: nil,
			next_of_kin_address: nil,
			next_of_kin_phone_number: nil
    ]
end
