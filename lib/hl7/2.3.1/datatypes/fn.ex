defmodule Hl7.V2_3_1.DataTypes.Fn do
  @moduledoc """
  The "FN" (FN) data type
  """

  use Hl7.DataType,
    fields: [
      family_name: nil,
      last_name_prefix: nil
    ]
end
