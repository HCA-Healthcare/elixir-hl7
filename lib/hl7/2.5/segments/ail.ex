defmodule Hl7.V2_5.Segments.AIL do
  @moduledoc """
  HL7 segment data structure for "AIL"
  """

  require Logger
  alias Hl7.V2_5.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_ail: nil,
      segment_action_code: nil,
      location_resource_id: DataTypes.Pl,
      location_type_ail: DataTypes.Ce,
      location_group: DataTypes.Ce,
      start_date_time: DataTypes.Ts,
      start_date_time_offset: nil,
      start_date_time_offset_units: DataTypes.Ce,
      duration: nil,
      duration_units: DataTypes.Ce,
      allow_substitution_code: nil,
      filler_status_code: DataTypes.Ce
    ]
end
