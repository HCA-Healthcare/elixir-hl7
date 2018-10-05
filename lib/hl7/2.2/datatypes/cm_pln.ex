defmodule HL7.V2_2.DataTypes.Cmpln do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			id_number: nil,
			type_of_id_number_id: nil,
			stateother_qualifiying_info: nil
    ]
end
