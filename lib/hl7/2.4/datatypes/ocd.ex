defmodule HL7.V2_4.DataTypes.Ocd do
  @moduledoc false

  use HL7.DataType,
    fields: [
      occurrence_code: nil,
      occurrence_date: nil
    ]
end
