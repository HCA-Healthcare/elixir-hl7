defmodule Hl7.V2_5_1.Segments.ECR do
  @moduledoc """
  HL7 segment data structure for "ECR"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      command_response: DataTypes.Ce,
      date_time_completed: DataTypes.Ts,
      command_response_parameters: nil
    ]
end
