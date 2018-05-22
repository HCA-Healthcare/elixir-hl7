defmodule Hl7.V2_4.Segments.CNS do
  @moduledoc """
  HL7 segment data structure for "CNS"
  """

  require Logger
  alias Hl7.V2_4.{DataTypes}

  use Hl7.Segment,
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
