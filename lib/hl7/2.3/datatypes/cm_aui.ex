defmodule HL7.V2_3.DataTypes.Cmaui do
  @moduledoc false
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
			authorization_number: nil,
			date: DataTypes.Ts,
			source: nil
    ]
end
