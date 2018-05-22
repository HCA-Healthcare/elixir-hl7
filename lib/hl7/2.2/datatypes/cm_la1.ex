defmodule Hl7.V2_2.DataTypes.Cmla1 do
  @moduledoc """
  The "CM_LA1" (CM_LA1) data type
  """
  alias Hl7.V2_2.{DataTypes}

  use Hl7.DataType,
    fields: [
      dispense_deliver_to_location: nil,
      location: DataTypes.Ad
    ]
end
