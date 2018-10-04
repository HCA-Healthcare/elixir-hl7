defmodule HL7.V2_3.DataTypes.Qsc do
  @moduledoc """
  The "QSC" (QSC) data type
  """

  use HL7.DataType,
    fields: [
      name_of_field: nil,
      relational_operator: nil,
      value: nil,
      relational_conjunction: nil
    ]
end
