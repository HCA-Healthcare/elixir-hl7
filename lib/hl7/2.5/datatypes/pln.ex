defmodule HL7.V2_5.DataTypes.Pln do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			id_number: nil,
			type_of_id_number: nil,
			stateother_qualifying_information: nil,
			expiration_date: nil
    ]
end
