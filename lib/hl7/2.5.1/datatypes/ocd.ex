defmodule HL7.V2_5_1.DataTypes.Ocd do
  @moduledoc false
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
      occurrence_code: DataTypes.Cne,
      occurrence_date: nil
    ]
end
