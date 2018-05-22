defmodule Hl7.V2_2.Segments.MFA do
  @moduledoc """
  HL7 segment data structure for "MFA"
  """

  require Logger
  alias Hl7.V2_2.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      record_level_event_code: nil,
      mfn_control_id: nil,
      event_completion_date_time: DataTypes.Ts,
      error_return_code_and_or_text: DataTypes.Ce,
      primary_key_value: DataTypes.Ce
    ]
end
