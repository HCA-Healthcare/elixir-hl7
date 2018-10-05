defmodule HL7.V2_1.Segments.MSH do
  @moduledoc false

  require Logger
  
  use HL7.Segment,
    fields: [
      segment: nil,
			field_separator: nil,
			encoding_characters: nil,
			sending_application: nil,
			sending_facility: nil,
			receiving_application: nil,
			receiving_facility: nil,
			date_time_of_message: nil,
			security: nil,
			message_type: nil,
			message_control_id: nil,
			processing_id: nil,
			version_id: nil,
			sequence_number: nil,
			continuation_pointer: nil
    ]
end
