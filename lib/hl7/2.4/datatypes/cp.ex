defmodule Hl7.V2_4.DataTypes.Cp do
  @moduledoc """
  The "CP" (CP) data type
  """
  alias Hl7.V2_4.{DataTypes}

  use Hl7.DataType,
    fields: [
      price: DataTypes.Mo,
      price_type: nil,
      from_value: nil,
      to_value: nil,
      range_units: DataTypes.Ce,
      range_type: nil
    ]
end
