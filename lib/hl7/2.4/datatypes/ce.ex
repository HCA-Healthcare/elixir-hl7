defmodule HL7.V2_4.DataTypes.Ce do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			identifier_st: nil,
			text: nil,
			name_of_coding_system: nil,
			alternate_identifier_st: nil,
			alternate_text: nil,
			name_of_alternate_coding_system: nil
    ]
end
