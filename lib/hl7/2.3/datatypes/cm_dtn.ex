defmodule HL7.V2_3.DataTypes.Cmdtn do
  @moduledoc """
  The "CM_DTN" (CM_DTN) data type
  """

  use HL7.DataType,
    fields: [
      day_type: nil,
      number_of_days: nil
    ]
end
