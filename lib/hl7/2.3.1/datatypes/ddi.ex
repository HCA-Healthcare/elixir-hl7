defmodule Hl7.V2_3_1.DataTypes.Ddi do
  @moduledoc """
  The "DDI" (DDI) data type
  """

  use Hl7.DataType,
    fields: [
      delay_days: nil,
      amount: nil,
      number_of_days: nil
    ]
end
