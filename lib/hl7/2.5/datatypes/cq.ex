defmodule HL7.V2_5.DataTypes.Cq do
  @moduledoc false
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
      quantity: nil,
      units: DataTypes.Ce
    ]
end
