defmodule Hl7.V2_2.Segments.ORC do
  @moduledoc """
  HL7 segment data structure for "ORC"
  """

  require Logger
  alias Hl7.V2_2.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      order_control: nil,
      placer_order_number: nil,
      filler_order_number: nil,
      placer_group_number: nil,
      order_status: nil,
      response_flag: nil,
      quantity_timing: DataTypes.Tq,
      parent: nil,
      date_time_of_transaction: DataTypes.Ts,
      entered_by: nil,
      verified_by: nil,
      ordering_provider: nil,
      enterers_location: nil,
      call_back_phone_number: nil,
      order_effective_date_time: DataTypes.Ts,
      order_control_code_reason: DataTypes.Ce,
      entering_organization: DataTypes.Ce,
      entering_device: DataTypes.Ce,
      action_by: nil
    ]
end
