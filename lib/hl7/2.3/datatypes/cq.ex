defmodule HL7.V2_3.DataTypes.Cq do
  @moduledoc false
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
      quantity: nil,
      units: DataTypes.Ce
    ]
end
