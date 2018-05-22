defmodule Hl7.V2_5.DataTypes.Ddi do
  @moduledoc """
  The "DDI" (DDI) data type
  """
  alias Hl7.V2_5.{DataTypes}

  use Hl7.DataType,
    fields: [
      delay_days: nil,
      monetary_amount: DataTypes.Mo,
      number_of_days: nil
    ]
end
