defmodule HL7.V2_1.Segments.RX1 do
  @moduledoc """
  HL7 segment data structure for "RX1"
  """

  require Logger
  alias HL7.V2_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      unused: nil,
      unused: nil,
      route: nil,
      site_administered: nil,
      iv_solution_rate: nil,
      drug_strength: nil,
      final_concentration: nil,
      final_volume_in_ml: nil,
      drug_dose: nil,
      drug_role: nil,
      prescription_sequence_: nil,
      quantity_dispensed: nil,
      unused: nil,
      drug_id: DataTypes.Ce,
      component_drug_ids: nil,
      prescription_type: nil,
      substitution_status: nil,
      rx_order_status: nil,
      number_of_refills: nil,
      unused: nil,
      refills_remaining: nil,
      dea_class: nil,
      ordering_mds_dea_number: nil,
      unused: nil,
      last_refill_date_time: nil,
      rx_number: nil,
      prn_status: nil,
      pharmacy_instructions: nil,
      patient_instructions: nil,
      instructions_sig: nil
    ]
end
