defmodule HL7.V2_1.Segments.URS do
  @moduledoc """
  HL7 segment data structure for "URS"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      r_u_where_subject_definition: nil,
      r_u_when_data_start_date_time: nil,
      r_u_when_data_end_date_time: nil,
      r_u_what_user_qualifier: nil,
      r_u_other_results_subject_defini: nil
    ]
end
