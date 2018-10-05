defmodule HL7.V2_2.DataTypes.Cmplacer do
  @moduledoc false

  use HL7.DataType,
    fields: [
      unique_placer_id: nil,
      placer_application: nil
    ]
end
