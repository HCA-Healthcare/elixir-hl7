defmodule HL7.V2_5.Segments.TQ2 do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_tq2: nil,
      sequence_results_flag: nil,
      related_placer_number: DataTypes.Ei,
      related_filler_number: DataTypes.Ei,
      related_placer_group_number: DataTypes.Ei,
      sequence_condition_code: nil,
      cyclic_entry_exit_indicator: nil,
      sequence_condition_time_interval: DataTypes.Cq,
      cyclic_group_maximum_number_of_repeats: nil,
      special_service_request_relationship: nil
    ]
end
