defmodule HL7.V2_5_1.Segments.ECD do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      reference_command_number: nil,
      remote_control_command: DataTypes.Ce,
      response_required: nil,
      requested_completion_time: DataTypes.Tq,
      parameters: nil
    ]
end
