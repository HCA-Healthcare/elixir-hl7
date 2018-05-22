defmodule Hl7.V2_3_1.DataTypes.Rp do
  @moduledoc """
  The "RP" (RP) data type
  """
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      pointer: nil,
      application_id: DataTypes.Hd,
      type_of_data: nil,
      subtype: nil
    ]
end
