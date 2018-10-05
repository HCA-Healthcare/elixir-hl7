defmodule HL7.V2_2.Segments.RXD do
  @moduledoc false

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      dispense_sub_id_counter: nil,
      dispense_give_code: DataTypes.Ce,
      date_time_dispensed: DataTypes.Ts,
      actual_dispense_amount: nil,
      actual_dispense_units: DataTypes.Ce,
      actual_dosage_form: DataTypes.Ce,
      prescription_number: nil,
      number_of_refills_remaining: nil,
      dispense_notes: nil,
      dispensing_provider: nil,
      substitution_status: nil,
      total_daily_dose: nil,
      deliver_to_location: nil,
      needs_human_review: nil,
      pharmacy_special_dispensing_instructions: DataTypes.Ce
    ]
end
