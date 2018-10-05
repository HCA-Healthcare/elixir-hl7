defmodule HL7.V2_5.Segments.MRG do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      prior_patient_identifier_list: DataTypes.Cx,
      prior_alternate_patient_id: DataTypes.Cx,
      prior_patient_account_number: DataTypes.Cx,
      prior_patient_id: DataTypes.Cx,
      prior_visit_number: DataTypes.Cx,
      prior_alternate_visit_id: DataTypes.Cx,
      prior_patient_name: DataTypes.Xpn
    ]
end
