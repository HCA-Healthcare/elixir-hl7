defmodule Hl7.V2_5.DataTypes.Ocd do
  @moduledoc """
  The "OCD" (OCD) data type
  """
  alias Hl7.V2_5.{DataTypes}

  use Hl7.DataType,
    fields: [
      occurrence_code: DataTypes.Cne,
      occurrence_date: nil
    ]
end
