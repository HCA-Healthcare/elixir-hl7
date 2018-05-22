defmodule Hl7.V2_5_1.Segments.RGS do
  @moduledoc """
  HL7 segment data structure for "RGS"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_rgs: nil,
      segment_action_code: nil,
      resource_group_id: DataTypes.Ce
    ]
end
