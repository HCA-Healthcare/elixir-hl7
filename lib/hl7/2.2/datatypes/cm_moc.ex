defmodule HL7.V2_2.DataTypes.Cmmoc do
  @moduledoc """
  The "CM_MOC" (CM_MOC) data type
  """

  use HL7.DataType,
    fields: [
      dollar_amount: nil,
      charge_code: nil
    ]
end
