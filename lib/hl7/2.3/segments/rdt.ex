defmodule HL7.V2_3.Segments.RDT do
  @moduledoc """
  HL7 segment data structure for "RDT"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      column_value: nil
    ]
end
