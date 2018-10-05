defmodule HL7.V2_3_1.DataTypes.Hd do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			namespace_id: nil,
			universal_id: nil,
			universal_id_type: nil
    ]
end
