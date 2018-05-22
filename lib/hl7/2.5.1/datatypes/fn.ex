defmodule Hl7.V2_5_1.DataTypes.Fn do
  @moduledoc """
  The "FN" (FN) data type
  """

  use Hl7.DataType,
    fields: [
      surname: nil,
      own_surname_prefix: nil,
      own_surname: nil,
      surname_prefix_from_partnerspouse: nil,
      surname_from_partnerspouse: nil
    ]
end
