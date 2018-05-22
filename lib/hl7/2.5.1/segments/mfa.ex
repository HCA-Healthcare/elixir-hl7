defmodule Hl7.V2_5_1.Segments.MFA do
  @moduledoc """
  HL7 segment data structure for "MFA"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      record_level_event_code: nil,
      mfn_control_id: nil,
      event_completion_date_time: DataTypes.Ts,
      mfn_record_level_error_return: DataTypes.Ce,
      primary_key_value_mfa: nil,
      primary_key_value_type_mfa: nil
    ]
end
