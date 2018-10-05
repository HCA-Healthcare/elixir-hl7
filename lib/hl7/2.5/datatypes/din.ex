defmodule HL7.V2_5.DataTypes.Din do
  @moduledoc false
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
      date: DataTypes.Ts,
      institution_name: DataTypes.Ce
    ]
end
