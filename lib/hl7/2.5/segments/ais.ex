defmodule HL7.V2_5.Segments.AIS do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_ais: nil,
      segment_action_code: nil,
      universal_service_identifier: DataTypes.Ce,
      start_date_time: DataTypes.Ts,
      start_date_time_offset: nil,
      start_date_time_offset_units: DataTypes.Ce,
      duration: nil,
      duration_units: DataTypes.Ce,
      allow_substitution_code: nil,
      filler_status_code: DataTypes.Ce,
      placer_supplemental_service_information: DataTypes.Ce,
      filler_supplemental_service_information: DataTypes.Ce
    ]
end
