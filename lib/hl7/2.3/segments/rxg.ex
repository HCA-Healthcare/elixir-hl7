defmodule HL7.V2_3.Segments.RXG do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      give_sub_id_counter: nil,
      dispense_sub_id_counter: nil,
      quantity_timing: DataTypes.Tq,
      give_code: DataTypes.Ce,
      give_amount_minimum: nil,
      give_amount_maximum: nil,
      give_units: DataTypes.Ce,
      give_dosage_form: DataTypes.Ce,
      administration_notes: DataTypes.Ce,
      substitution_status: nil,
      dispense_to_location: nil,
      needs_human_review: nil,
      pharmacy_special_administration_instructions: DataTypes.Ce,
      give_per_time_unit: nil,
      give_rate_amount: nil,
      give_rate_units: DataTypes.Ce,
      give_strength: nil,
      give_strength_units: DataTypes.Ce,
      substance_lot_number: nil,
      substance_expiration_date: DataTypes.Ts,
      substance_manufacturer_name: DataTypes.Ce,
      indication: DataTypes.Ce
    ]
end
