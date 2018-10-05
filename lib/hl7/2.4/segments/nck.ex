defmodule HL7.V2_4.Segments.NCK do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			system_date_time: DataTypes.Ts
    ]
end
