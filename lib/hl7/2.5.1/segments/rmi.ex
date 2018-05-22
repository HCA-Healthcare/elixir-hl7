defmodule Hl7.V2_5_1.Segments.RMI do
  @moduledoc """
  HL7 segment data structure for "RMI"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      risk_management_incident_code: DataTypes.Ce,
      date_time_incident: DataTypes.Ts,
      incident_type_code: DataTypes.Ce
    ]
end
