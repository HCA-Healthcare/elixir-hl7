defmodule Hl7.V2_5.Segments.RDT do
  @moduledoc """
  HL7 segment data structure for "RDT"
  """

  require Logger

  use Hl7.Segment,
    fields: [
      segment: nil,
      column_value: nil
    ]
end
