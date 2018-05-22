defmodule Hl7.V2_5_1.Segments.BPO do
  @moduledoc """
  HL7 segment data structure for "BPO"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_bpo: nil,
      bp_universal_service_id: DataTypes.Cwe,
      bp_processing_requirements: DataTypes.Cwe,
      bp_quantity: nil,
      bp_amount: nil,
      bp_units: DataTypes.Ce,
      bp_intended_use_date_time: DataTypes.Ts,
      bp_intended_dispense_from_location: DataTypes.Pl,
      bp_intended_dispense_from_address: DataTypes.Xad,
      bp_requested_dispense_date_time: DataTypes.Ts,
      bp_requested_dispense_to_location: DataTypes.Pl,
      bp_requested_dispense_to_address: DataTypes.Xad,
      bp_indication_for_use: DataTypes.Cwe,
      bp_informed_consent_indicator: nil
    ]
end
