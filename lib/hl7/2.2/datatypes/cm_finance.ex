defmodule Hl7.V2_2.DataTypes.Cmfinance do
  @moduledoc """
  The "CM_FINANCE" (CM_FINANCE) data type
  """
  alias Hl7.V2_2.{DataTypes}

  use Hl7.DataType,
    fields: [
      financial_class_id: nil,
      effective_date: DataTypes.Ts
    ]
end
