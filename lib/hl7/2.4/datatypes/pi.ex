defmodule HL7.V2_4.DataTypes.Pi do
  @moduledoc """
  The "PI" (PI) data type
  """

  use HL7.DataType,
    fields: [
      id_number_st: nil,
      type_of_id_number_is: nil,
      other_qualifying_info: nil
    ]
end
