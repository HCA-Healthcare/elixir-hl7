defmodule HL7.V2_5.Segments.ECR do
  @moduledoc """
  HL7 segment data structure for "ECR"
  """

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      command_response: DataTypes.Ce,
      date_time_completed: DataTypes.Ts,
      command_response_parameters: nil
    ]
end
