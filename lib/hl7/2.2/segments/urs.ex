defmodule HL7.V2_2.Segments.URS do
  @moduledoc """
  HL7 segment data structure for "URS"
  """

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      r_u_where_subject_definition: nil,
      r_u_when_data_start_date_time: DataTypes.Ts,
      r_u_when_data_end_date_time: DataTypes.Ts,
      r_u_what_user_qualifier: nil,
      r_u_other_results_subject_definition: nil,
      r_u_which_date_time_qualifier: nil,
      r_u_which_date_time_status_qualifier: nil,
      r_u_date_time_selection_qualifier: nil
    ]
end
