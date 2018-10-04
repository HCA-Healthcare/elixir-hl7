defmodule HL7.V2_4.Segments.QID do
  @moduledoc """
  HL7 segment data structure for "QID"
  """

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      query_tag: nil,
      message_query_name: DataTypes.Ce
    ]
end
