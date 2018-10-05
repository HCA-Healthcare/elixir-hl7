defmodule HL7.V2_5.Segments.QAK do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			query_tag: nil,
			query_response_status: nil,
			message_query_name: DataTypes.Ce,
			hit_count: nil,
			this_payload: nil,
			hits_remaining: nil
    ]
end
