defmodule HL7.V2_2.DataTypes.Cmeld do
  @moduledoc false
  alias HL7.V2_2.{DataTypes}

  use HL7.DataType,
    fields: [
      segmentid: nil,
      sequence: nil,
      fieldposition: nil,
      code_identifying_error: DataTypes.Ce
    ]
end
