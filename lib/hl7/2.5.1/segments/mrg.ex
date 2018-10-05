defmodule HL7.V2_5_1.Segments.MRG do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

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
