defmodule Hl7.V2_4.Segments.MRG do
  @moduledoc """
  HL7 segment data structure for "MRG"
  """

  require Logger
  alias Hl7.V2_4.{DataTypes}

  use Hl7.Segment,
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
