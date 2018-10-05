defmodule HL7.V2_3_1.DataTypes.Eld do
  @moduledoc false
  alias HL7.V2_3_1.{DataTypes}

  use HL7.DataType,
    fields: [
			segment_id: nil,
			sequence: nil,
			field_position: nil,
			code_identifying_error: DataTypes.Ce
    ]
end
