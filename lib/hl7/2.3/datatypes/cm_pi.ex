defmodule HL7.V2_3.DataTypes.Cmpi do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			id_number_st: nil,
			type_of_id_number_is: nil,
			other_qualifying_info: nil
    ]
end
