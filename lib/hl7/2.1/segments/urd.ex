defmodule HL7.V2_1.Segments.URD do
  @moduledoc """
  HL7 segment data structure for "URD"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      r_u_date_time: nil,
      report_priority: nil,
      r_u_who_subject_definition: nil,
      r_u_what_subject_definition: nil,
      r_u_what_department_code: nil,
      r_u_display_print_locations: nil,
      r_u_results_level: nil
    ]
end
