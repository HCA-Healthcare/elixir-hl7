defmodule HL7.V2_3.DataTypes.Cmeld do
  @moduledoc false
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
      segment_id: nil,
      sequence: nil,
      field_position: nil,
      code_identifying_error: DataTypes.Ce
    ]
end
