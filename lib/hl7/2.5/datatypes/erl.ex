defmodule HL7.V2_5.DataTypes.Erl do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			segment_id: nil,
			segment_sequence: nil,
			field_position: nil,
			field_repetition: nil,
			component_number: nil,
			subcomponent_number: nil
    ]
end
