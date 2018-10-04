defmodule HL7.V2_5.DataTypes.Ocd do
  @moduledoc """
  The "OCD" (OCD) data type
  """
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
      occurrence_code: DataTypes.Cne,
      occurrence_date: nil
    ]
end
