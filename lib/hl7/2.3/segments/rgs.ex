defmodule HL7.V2_3.Segments.RGS do
  @moduledoc """
  HL7 segment data structure for "RGS"
  """

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_rgs: nil,
      segment_action_code: nil,
      resource_group_id: DataTypes.Ce
    ]
end
