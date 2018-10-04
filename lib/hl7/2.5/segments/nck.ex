defmodule HL7.V2_5.Segments.NCK do
  @moduledoc """
  HL7 segment data structure for "NCK"
  """

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      system_date_time: DataTypes.Ts
    ]
end
