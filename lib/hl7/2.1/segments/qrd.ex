defmodule Hl7.V2_1.Segments.QRD do
  @moduledoc """
  HL7 segment data structure for "QRD"
  """

  require Logger

  use Hl7.Segment,
    fields: [
      segment: nil,
      query_date_time: nil,
      query_format_code: nil,
      query_priority: nil,
      query_id: nil,
      deferred_response_type: nil,
      deferred_response_date_time: nil,
      quantity_limited_request: nil,
      who_subject_filter: nil,
      what_subject_filter: nil,
      what_department_data_code: nil,
      what_data_code_value_qual: nil,
      query_results_level: nil
    ]
end
