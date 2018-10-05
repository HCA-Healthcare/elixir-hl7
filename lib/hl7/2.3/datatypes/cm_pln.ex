defmodule HL7.V2_3.DataTypes.Cmpln do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			id_number: nil,
			type_of_id_number_is: nil,
			stateother_qualifying_info: nil,
			expiration_date: nil
    ]
end
