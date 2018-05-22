defmodule Hl7.V2_5_1.DataTypes.Dlt do
  @moduledoc """
  The "DLT" (DLT) data type
  """
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      normal_range: DataTypes.Nr,
      numeric_threshold: nil,
      change_computation: nil,
      days_retained: nil
    ]
end
