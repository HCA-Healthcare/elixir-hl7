defmodule HL7.V2_5.Segments.BPX do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_bpx: nil,
      bp_dispense_status: DataTypes.Cwe,
      bp_status: nil,
      bp_date_time_of_status: DataTypes.Ts,
      bc_donation_id: DataTypes.Ei,
      bc_component: DataTypes.Cne,
      bc_donation_type_intended_use: DataTypes.Cne,
      cp_commercial_product: DataTypes.Cwe,
      cp_manufacturer: DataTypes.Xon,
      cp_lot_number: DataTypes.Ei,
      bp_blood_group: DataTypes.Cne,
      bc_special_testing: DataTypes.Cne,
      bp_expiration_date_time: DataTypes.Ts,
      bp_quantity: nil,
      bp_amount: nil,
      bp_units: DataTypes.Ce,
      bp_unique_id: DataTypes.Ei,
      bp_actual_dispensed_to_location: DataTypes.Pl,
      bp_actual_dispensed_to_address: DataTypes.Xad,
      bp_dispensed_to_receiver: DataTypes.Xcn,
      bp_dispensing_individual: DataTypes.Xcn
    ]
end
