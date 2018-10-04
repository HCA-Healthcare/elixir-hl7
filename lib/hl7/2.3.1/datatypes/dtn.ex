defmodule HL7.V2_3_1.DataTypes.Dtn do
  @moduledoc """
  The "DTN" (DTN) data type
  """

  use HL7.DataType,
    fields: [
      day_type: nil,
      number_of_days: nil
    ]
end
