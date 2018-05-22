defmodule Hl7.V2_5.Segments.BTX do
  @moduledoc """
  HL7 segment data structure for "BTX"
  """

  require Logger
  alias Hl7.V2_5.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_btx: nil,
      bc_donation_id: DataTypes.Ei,
      bc_component: DataTypes.Cne,
      bc_blood_group: DataTypes.Cne,
      cp_commercial_product: DataTypes.Cwe,
      cp_manufacturer: DataTypes.Xon,
      cp_lot_number: DataTypes.Ei,
      bp_quantity: nil,
      bp_amount: nil,
      bp_units: DataTypes.Ce,
      bp_transfusion_disposition_status: DataTypes.Cwe,
      bp_message_status: nil,
      bp_date_time_of_status: DataTypes.Ts,
      bp_administrator: DataTypes.Xcn,
      bp_verifier: DataTypes.Xcn,
      bp_transfusion_start_date_time_of_status: DataTypes.Ts,
      bp_transfusion_end_date_time_of_status: DataTypes.Ts,
      bp_adverse_reaction_type: DataTypes.Cwe,
      bp_transfusion_interrupted_reason: DataTypes.Cwe
    ]
end
