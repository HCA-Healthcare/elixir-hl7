defmodule Hl7.V2_3.DataTypes.Fc do
  @moduledoc """
  The "FC" (FC) data type
  """
  alias Hl7.V2_3.{DataTypes}

  use Hl7.DataType,
    fields: [
      financial_class: nil,
      effective_date: DataTypes.Ts
    ]
end
