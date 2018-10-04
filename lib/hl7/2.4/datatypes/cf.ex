defmodule HL7.V2_4.DataTypes.Cf do
  @moduledoc """
  The "CF" (CF) data type
  """

  use HL7.DataType,
    fields: [
      identifier_id: nil,
      formatted_text: nil,
      name_of_coding_system: nil,
      alternate_identifier_id: nil,
      alternate_formatted_text: nil,
      name_of_alternate_coding_system: nil
    ]
end
