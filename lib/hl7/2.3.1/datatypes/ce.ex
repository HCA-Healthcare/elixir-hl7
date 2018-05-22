defmodule Hl7.V2_3_1.DataTypes.Ce do
  @moduledoc """
  The "CE" (CE) data type
  """

  use Hl7.DataType,
    fields: [
      identifier: nil,
      text: nil,
      name_of_coding_system: nil,
      alternate_identifier: nil,
      alternate_text: nil,
      name_of_alternate_coding_system: nil
    ]
end
