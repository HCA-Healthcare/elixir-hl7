defmodule HL7.V2_2.Segments.RXE do
  @moduledoc """
  HL7 segment data structure for "RXE"
  """

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      quantity_timing: DataTypes.Tq,
      give_code: DataTypes.Ce,
      give_amount_minimum: nil,
      give_amount_maximum: nil,
      give_units: DataTypes.Ce,
      give_dosage_form: DataTypes.Ce,
      providers_administration_instructions: DataTypes.Ce,
      deliver_to_location: nil,
      substitution_status: nil,
      dispense_amount: nil,
      dispense_units: DataTypes.Ce,
      number_of_refills: nil,
      ordering_providers_dea_number: nil,
      pharmacist_verifier_id: nil,
      prescription_number: nil,
      number_of_refills_remaining: nil,
      number_of_refills_doses_dispensed: nil,
      date_time_of_most_recent_refill_or_dose_dispensed: DataTypes.Ts,
      total_daily_dose: nil,
      needs_human_review: nil,
      pharmacy_special_dispensing_instructions: DataTypes.Ce,
      give_per_time_unit: nil,
      give_rate_amount: DataTypes.Ce,
      give_rate_units: DataTypes.Ce
    ]
end
