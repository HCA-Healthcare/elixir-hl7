defmodule HL7.V2_5.Segments.QID do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      query_tag: nil,
      message_query_name: DataTypes.Ce
    ]
end
