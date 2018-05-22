defmodule Hl7.V2_5_1.DataTypes.Sad do
  @moduledoc """
  The "SAD" (SAD) data type
  """

  use Hl7.DataType,
    fields: [
      street_or_mailing_address: nil,
      street_name: nil,
      dwelling_number: nil
    ]
end
