defmodule Hl7.V2_5.Segments.ECD do
  @moduledoc """
  HL7 segment data structure for "ECD"
  """

  require Logger
  alias Hl7.V2_5.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      reference_command_number: nil,
      remote_control_command: DataTypes.Ce,
      response_required: nil,
      requested_completion_time: DataTypes.Tq,
      parameters: nil
    ]
end
