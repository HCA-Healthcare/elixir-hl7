defmodule HL7.V2_4.Segments.IN3 do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_in3: nil,
      certification_number: DataTypes.Cx,
      certified_by: DataTypes.Xcn,
      certification_required: nil,
      penalty: DataTypes.Mop,
      certification_date_time: DataTypes.Ts,
      certification_modify_date_time: DataTypes.Ts,
      operator: DataTypes.Xcn,
      certification_begin_date: nil,
      certification_end_date: nil,
      days: DataTypes.Dtn,
      non_concur_code_description: DataTypes.Ce,
      non_concur_effective_date_time: DataTypes.Ts,
      physician_reviewer: DataTypes.Xcn,
      certification_contact: nil,
      certification_contact_phone_number: DataTypes.Xtn,
      appeal_reason: DataTypes.Ce,
      certification_agency: DataTypes.Ce,
      certification_agency_phone_number: DataTypes.Xtn,
      pre_certification_req_window: DataTypes.Pcf,
      case_manager: nil,
      second_opinion_date: nil,
      second_opinion_status: nil,
      second_opinion_documentation_received: nil,
      second_opinion_physician: DataTypes.Xcn
    ]
end
