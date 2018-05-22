defmodule Hl7.V2_5.Segments.DSC do
  @moduledoc """
  HL7 segment data structure for "DSC"
  """

  require Logger

  use Hl7.Segment,
    fields: [
      segment: nil,
      continuation_pointer: nil,
      continuation_style: nil
    ]
end
