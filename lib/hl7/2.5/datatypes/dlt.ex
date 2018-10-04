defmodule HL7.V2_5.DataTypes.Dlt do
  @moduledoc """
  The "DLT" (DLT) data type
  """
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
      normal_range: DataTypes.Nr,
      numeric_threshold: nil,
      change_computation: nil,
      days_retained: nil
    ]
end
