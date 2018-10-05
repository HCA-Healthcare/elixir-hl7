defmodule HL7.V2_4.Segments.ORG do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_org: nil,
      organization_unit_code: DataTypes.Ce,
      organization_unit_type_code_org: DataTypes.Ce,
      primary_org_unit_indicator: nil,
      practitioner_org_unit_identifier: DataTypes.Cx,
      health_care_provider_type_code: DataTypes.Ce,
      health_care_provider_classification_code: DataTypes.Ce,
      health_care_provider_area_of_specialization_code: DataTypes.Ce,
      effective_date_range: DataTypes.Dr,
      employment_status_code: DataTypes.Ce,
      board_approval_indicator: nil,
      primary_care_physician_indicator: nil
    ]
end
