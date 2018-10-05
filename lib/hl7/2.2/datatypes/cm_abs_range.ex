defmodule HL7.V2_2.DataTypes.Cmabsrange do
  @moduledoc false

  use HL7.DataType,
    fields: [
      range: nil,
      numeric_change: nil,
      percent_per_change: nil,
      days: nil
    ]
end
