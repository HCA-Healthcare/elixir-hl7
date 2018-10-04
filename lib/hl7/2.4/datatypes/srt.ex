defmodule HL7.V2_4.DataTypes.Srt do
  @moduledoc """
  The "SRT" (SRT) data type
  """

  use HL7.DataType,
    fields: [
      sortby_field: nil,
      sequencing: nil
    ]
end
