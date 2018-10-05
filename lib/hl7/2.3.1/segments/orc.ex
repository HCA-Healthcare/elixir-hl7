defmodule HL7.V2_3_1.Segments.ORC do
  @moduledoc false

  require Logger
  alias HL7.V2_3_1.{DataTypes}

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
      parent: DataTypes.Eip,
      date_time_of_transaction: DataTypes.Ts,
      entered_by: DataTypes.Xcn,
      verified_by: DataTypes.Xcn,
      ordering_provider: DataTypes.Xcn,
      enterers_location: DataTypes.Pl,
      call_back_phone_number: DataTypes.Xtn,
      order_effective_date_time: DataTypes.Ts,
      order_control_code_reason: DataTypes.Ce,
      entering_organization: DataTypes.Ce,
      entering_device: DataTypes.Ce,
      action_by: DataTypes.Xcn,
      advanced_beneficiary_notice_code: DataTypes.Ce,
      ordering_facility_name: DataTypes.Xon,
      ordering_facility_address: DataTypes.Xad,
      ordering_facility_phone_number: DataTypes.Xtn,
      ordering_provider_address: DataTypes.Xad
    ]
end
