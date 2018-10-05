defmodule HL7.V2_2.Segments.NCK do
  @moduledoc false

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      system_date_time: DataTypes.Ts
    ]
end
