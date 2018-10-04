defmodule HL7.V2_3.DataTypes.Cmddi do
  @moduledoc """
  The "CM_DDI" (CM_DDI) data type
  """

  use HL7.DataType,
    fields: [
      delay_days: nil,
      amount: nil,
      number_of_days: nil
    ]
end
