defmodule HL7.V2_3.Segments.MRG do
  @moduledoc """
  HL7 segment data structure for "MRG"
  """

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      prior_patient_id_internal: DataTypes.Cx,
      prior_alternate_patient_id: DataTypes.Cx,
      prior_patient_account_number: DataTypes.Cx,
      prior_patient_id_external: DataTypes.Cx,
      prior_visit_number: DataTypes.Cx,
      prior_alternate_visit_id: DataTypes.Cx,
      prior_patient_name: DataTypes.Cx
    ]
end
