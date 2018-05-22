defmodule Hl7.V2_5.DataTypes.Dtn do
  @moduledoc """
  The "DTN" (DTN) data type
  """

  use Hl7.DataType,
    fields: [
      day_type: nil,
      number_of_days: nil
    ]
end
