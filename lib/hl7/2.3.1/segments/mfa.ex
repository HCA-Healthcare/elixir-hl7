defmodule HL7.V2_3_1.Segments.MFA do
  @moduledoc false

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      record_level_event_code: nil,
      mfn_control_id: nil,
      event_completion_date_time: DataTypes.Ts,
      mfn_record_level_error_return: DataTypes.Ce,
      primary_key_value_mfa: DataTypes.Ce,
      primary_key_value_type_mfa: nil
    ]
end
