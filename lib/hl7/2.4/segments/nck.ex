defmodule Hl7.V2_4.Segments.NCK do
  @moduledoc """
  HL7 segment data structure for "NCK"
  """

  require Logger
  alias Hl7.V2_4.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      system_date_time: DataTypes.Ts
    ]
end
