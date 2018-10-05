defmodule HL7.V2_5.Segments.CNS do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			starting_notification_reference_number: nil,
			ending_notification_reference_number: nil,
			starting_notification_date_time: DataTypes.Ts,
			ending_notification_date_time: DataTypes.Ts,
			starting_notification_code: DataTypes.Ce,
			ending_notification_code: DataTypes.Ce
    ]
end
