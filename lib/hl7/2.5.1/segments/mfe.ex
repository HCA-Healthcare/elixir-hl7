defmodule Hl7.V2_5_1.Segments.MFE do
  @moduledoc """
  HL7 segment data structure for "MFE"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      record_level_event_code: nil,
      mfn_control_id: nil,
      effective_date_time: DataTypes.Ts,
      primary_key_value_mfe: nil,
      primary_key_value_type: nil
    ]
end
