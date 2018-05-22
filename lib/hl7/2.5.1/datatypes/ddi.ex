defmodule Hl7.V2_5_1.DataTypes.Ddi do
  @moduledoc """
  The "DDI" (DDI) data type
  """
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      delay_days: nil,
      monetary_amount: DataTypes.Mo,
      number_of_days: nil
    ]
end
