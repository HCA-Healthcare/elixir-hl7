defmodule Hl7.V2_2.DataTypes.Cmdtn do
  @moduledoc """
  The "CM_DTN" (CM_DTN) data type
  """

  use Hl7.DataType,
    fields: [
      day_type: nil,
      number_of_days: nil
    ]
end
