defmodule Hl7.V2_5_1.Segments.QAK do
  @moduledoc """
  HL7 segment data structure for "QAK"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
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
