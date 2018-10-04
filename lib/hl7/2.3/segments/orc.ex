defmodule HL7.V2_3.Segments.ORC do
  @moduledoc """
  HL7 segment data structure for "ORC"
  """

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      order_control: nil,
      placer_order_number: DataTypes.Ei,
      filler_order_number: DataTypes.Ei,
      placer_group_number: DataTypes.Ei,
      order_status: nil,
      response_flag: nil,
      quantity_timing: DataTypes.Tq,
      parent: nil,
      date_time_of_transaction: DataTypes.Ts,
      entered_by: DataTypes.Xcn,
      verified_by: DataTypes.Xcn,
      ordering_provider: DataTypes.Xcn,
      enterers_location: DataTypes.Pl,
      call_back_phone_number: nil,
      order_effective_date_time: DataTypes.Ts,
      order_control_code_reason: DataTypes.Ce,
      entering_organization: DataTypes.Ce,
      entering_device: DataTypes.Ce,
      action_by: DataTypes.Xcn
    ]
end
