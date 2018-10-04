defmodule HL7.V2_2.DataTypes.Cmocd do
  @moduledoc """
  The "CM_OCD" (CM_OCD) data type
  """

  use HL7.DataType,
    fields: [
      occurrence_code: nil,
      occurrence_date: nil
    ]
end
