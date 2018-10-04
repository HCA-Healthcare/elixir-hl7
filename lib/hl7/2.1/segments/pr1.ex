defmodule HL7.V2_1.Segments.PR1 do
  @moduledoc """
  HL7 segment data structure for "PR1"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_procedure: nil,
      procedure_coding_method: nil,
      procedure_code: nil,
      procedure_description: nil,
      procedure_date_time: nil,
      procedure_type: nil,
      procedure_minutes: nil,
      anesthesiologist: nil,
      anesthesia_code: nil,
      anesthesia_minutes: nil,
      surgeon: nil,
      resident_code: nil,
      consent_code: nil
    ]
end
