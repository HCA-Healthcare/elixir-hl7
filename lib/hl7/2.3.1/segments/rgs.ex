defmodule HL7.V2_3_1.Segments.RGS do
  @moduledoc false

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_rgs: nil,
			segment_action_code: nil,
			resource_group_id: DataTypes.Ce
    ]
end
