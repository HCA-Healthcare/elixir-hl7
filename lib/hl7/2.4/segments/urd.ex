defmodule HL7.V2_4.Segments.URD do
  @moduledoc """
  HL7 segment data structure for "URD"
  """

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      r_u_date_time: DataTypes.Ts,
      report_priority: nil,
      r_u_who_subject_definition: DataTypes.Xcn,
      r_u_what_subject_definition: DataTypes.Ce,
      r_u_what_department_code: DataTypes.Ce,
      r_u_display_print_locations: nil,
      r_u_results_level: nil
    ]
end
