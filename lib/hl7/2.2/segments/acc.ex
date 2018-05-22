defmodule Hl7.V2_2.Segments.ACC do
  @moduledoc """
  HL7 segment data structure for "ACC"
  """

  require Logger
  alias Hl7.V2_2.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      accident_date_time: DataTypes.Ts,
      accident_code: nil,
      accident_location: nil
    ]
end
