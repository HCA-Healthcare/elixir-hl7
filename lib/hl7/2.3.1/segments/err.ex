defmodule Hl7.V2_3_1.Segments.ERR do
  @moduledoc """
  HL7 segment data structure for "ERR"
  """

  require Logger
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      error_code_and_location: DataTypes.Eld
    ]
end
