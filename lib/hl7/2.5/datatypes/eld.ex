defmodule HL7.V2_5.DataTypes.Eld do
  @moduledoc false
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
      segment_id: nil,
      segment_sequence: nil,
      field_position: nil,
      code_identifying_error: DataTypes.Ce
    ]
end
