defmodule Hl7.V2_4.Segments.NDS do
  @moduledoc """
  HL7 segment data structure for "NDS"
  """

  require Logger
  alias Hl7.V2_4.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      notification_reference_number: nil,
      notification_date_time: DataTypes.Ts,
      notification_alert_severity: DataTypes.Ce,
      notification_code: DataTypes.Ce
    ]
end
