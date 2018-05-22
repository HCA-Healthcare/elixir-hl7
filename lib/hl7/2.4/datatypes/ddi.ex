defmodule Hl7.V2_4.DataTypes.Ddi do
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
