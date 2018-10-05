defmodule HL7.V2_5_1.Segments.RMI do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      risk_management_incident_code: DataTypes.Ce,
      date_time_incident: DataTypes.Ts,
      incident_type_code: DataTypes.Ce
    ]
end
