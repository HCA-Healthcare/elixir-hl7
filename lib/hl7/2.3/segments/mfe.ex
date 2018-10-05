defmodule HL7.V2_3.Segments.MFE do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			record_level_event_code: nil,
			mfn_control_id: nil,
			effective_date_time: DataTypes.Ts,
			primary_key_value: DataTypes.Ce
    ]
end
