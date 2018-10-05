defmodule HL7.V2_2.DataTypes.Cmfiller do
  @moduledoc false

  use HL7.DataType,
    fields: [
      unique_filler_id: nil,
      filler_application_id: nil
    ]
end
