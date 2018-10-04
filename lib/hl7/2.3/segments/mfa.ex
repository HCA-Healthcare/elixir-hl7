defmodule HL7.V2_3.Segments.MFA do
  @moduledoc """
  HL7 segment data structure for "MFA"
  """

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      record_level_event_code: nil,
      mfn_control_id: nil,
      event_completion_date_time: DataTypes.Ts,
      error_return_code_and_or_text: DataTypes.Ce,
      primary_key_value: DataTypes.Ce
    ]
end
