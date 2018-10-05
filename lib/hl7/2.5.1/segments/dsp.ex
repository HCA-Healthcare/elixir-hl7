defmodule HL7.V2_5_1.Segments.DSP do
  @moduledoc false

  require Logger
  
  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_dsp: nil,
			display_level: nil,
			data_line: nil,
			logical_break_point: nil,
			result_id: nil
    ]
end
