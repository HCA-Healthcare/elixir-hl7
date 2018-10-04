defmodule HL7.V2_3.DataTypes.Cmpi do
  @moduledoc """
  The "CM_PI" (CM_PI) data type
  """

  use HL7.DataType,
    fields: [
      id_number_st: nil,
      type_of_id_number_is: nil,
      other_qualifying_info: nil
    ]
end
