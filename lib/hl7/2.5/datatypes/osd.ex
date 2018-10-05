defmodule HL7.V2_5.DataTypes.Osd do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			sequenceresults_flag: nil,
			placer_order_number_entity_identifier: nil,
			placer_order_number_namespace_id: nil,
			filler_order_number_entity_identifier: nil,
			filler_order_number_namespace_id: nil,
			sequence_condition_value: nil,
			maximum_number_of_repeats: nil,
			placer_order_number_universal_id: nil,
			placer_order_number_universal_id_type: nil,
			filler_order_number_universal_id: nil,
			filler_order_number_universal_id_type: nil
    ]
end
