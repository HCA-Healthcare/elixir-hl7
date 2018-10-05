defmodule HL7.V2_5.DataTypes.Cwe do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			identifier: nil,
			text: nil,
			name_of_coding_system: nil,
			alternate_identifier: nil,
			alternate_text: nil,
			name_of_alternate_coding_system: nil,
			coding_system_version_id: nil,
			alternate_coding_system_version_id: nil,
			original_text: nil
    ]
end
