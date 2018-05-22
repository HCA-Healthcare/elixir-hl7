defmodule Hl7.V2_3_1.DataTypes.Dlt do
  @moduledoc """
  The "DLT" (DLT) data type
  """
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      range: DataTypes.Nr,
      numeric_threshold: nil,
      change_computation: nil,
      length_of_timedays: nil
    ]
end
