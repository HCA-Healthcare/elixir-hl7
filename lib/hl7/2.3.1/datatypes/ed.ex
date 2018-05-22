defmodule Hl7.V2_3_1.DataTypes.Ed do
  @moduledoc """
  The "ED" (ED) data type
  """
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      source_application: DataTypes.Hd,
      type_of_data: nil,
      data: nil,
      encoding: nil,
      data: nil
    ]
end
