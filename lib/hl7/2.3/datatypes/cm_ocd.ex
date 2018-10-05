defmodule HL7.V2_3.DataTypes.Cmocd do
  @moduledoc false
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
			occurrence_code: DataTypes.Ce,
			occurrence_date: nil
    ]
end
