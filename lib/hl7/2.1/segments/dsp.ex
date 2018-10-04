defmodule HL7.V2_1.Segments.DSP do
  @moduledoc """
  HL7 segment data structure for "DSP"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_display_data: nil,
      display_level: nil,
      data_line: nil,
      logical_break_point: nil,
      result_id: nil
    ]
end
