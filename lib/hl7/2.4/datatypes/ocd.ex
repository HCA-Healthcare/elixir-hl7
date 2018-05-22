defmodule Hl7.V2_4.DataTypes.Ocd do
  @moduledoc """
  The "OCD" (OCD) data type
  """

  use Hl7.DataType,
    fields: [
      occurrence_code: nil,
      occurrence_date: nil
    ]
end
