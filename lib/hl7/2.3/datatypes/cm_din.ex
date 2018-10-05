defmodule HL7.V2_3.DataTypes.Cmdin do
  @moduledoc false
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
      date: DataTypes.Ts,
      institution_name: DataTypes.Ce
    ]
end
