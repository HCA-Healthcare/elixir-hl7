defmodule Hl7.V2_5.Segments.PTH do
  @moduledoc """
  HL7 segment data structure for "PTH"
  """

  require Logger
  alias Hl7.V2_5.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      action_code: nil,
      pathway_id: DataTypes.Ce,
      pathway_instance_id: DataTypes.Ei,
      pathway_established_date_time: DataTypes.Ts,
      pathway_life_cycle_status: DataTypes.Ce,
      change_pathway_life_cycle_status_date_time: DataTypes.Ts
    ]
end
