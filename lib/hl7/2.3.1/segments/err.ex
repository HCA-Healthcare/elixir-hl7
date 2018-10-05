defmodule HL7.V2_3_1.Segments.ERR do
  @moduledoc false

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      error_code_and_location: DataTypes.Eld
    ]
end
