defmodule HL7.V2_3_1.DataTypes.Pln do
  @moduledoc """
  The "PLN" (PLN) data type
  """

  use HL7.DataType,
    fields: [
      id_number_st: nil,
      type_of_id_number_is: nil,
      stateother_qualifying_info: nil,
      expiration_date: nil
    ]
end
