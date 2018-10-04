defmodule HL7.V2_3.DataTypes.Cmpln do
  @moduledoc """
  The "CM_PLN" (CM_PLN) data type
  """

  use HL7.DataType,
    fields: [
      id_number: nil,
      type_of_id_number_is: nil,
      stateother_qualifying_info: nil,
      expiration_date: nil
    ]
end
