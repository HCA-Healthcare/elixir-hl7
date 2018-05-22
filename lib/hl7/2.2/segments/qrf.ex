defmodule Hl7.V2_2.Segments.QRF do
  @moduledoc """
  HL7 segment data structure for "QRF"
  """

  require Logger
  alias Hl7.V2_2.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      where_subject_filter: nil,
      when_data_start_date_time: DataTypes.Ts,
      when_data_end_date_time: DataTypes.Ts,
      what_user_qualifier: nil,
      other_qry_subject_filter: nil,
      which_date_time_qualifier: nil,
      which_date_time_status_qualifier: nil,
      date_time_selection_qualifier: nil
    ]
end
