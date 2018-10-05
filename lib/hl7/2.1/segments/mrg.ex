defmodule HL7.V2_1.Segments.MRG do
  @moduledoc false

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      prior_patient_id_internal: nil,
      prior_alternate_patient_id: nil,
      prior_patient_account_number: nil
    ]
end
