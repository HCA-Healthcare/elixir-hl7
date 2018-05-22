defmodule Hl7.V2_1.Segments.ORC do
  @moduledoc """
  HL7 segment data structure for "ORC"
  """

  require Logger

  use Hl7.Segment,
    fields: [
      segment: nil,
      order_control: nil,
      placer_order_: nil,
      filler_order_: nil,
      placer_group_: nil,
      order_status: nil,
      response_flag: nil,
      timing_quantity: nil,
      parent: nil,
      date_time_of_transaction: nil,
      entered_by: nil,
      verified_by: nil,
      ordering_provider: nil,
      enterers_location: nil,
      call_back_phone_number: nil
    ]
end
