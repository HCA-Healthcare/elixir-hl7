defmodule HL7.V2_2.DataTypes.Cmposition do
  @moduledoc """
  The "CM_POSITION" (CM_POSITION) data type
  """

  use HL7.DataType,
    fields: [
      saal: nil,
      tisch: nil,
      stuhl: nil
    ]
end
