defmodule HL7.V2_3.Segments.RXD do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

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
      dispense_notes: DataTypes.Ce,
      dispensing_provider: DataTypes.Xcn,
      substitution_status: nil,
      total_daily_dose: DataTypes.Cq,
      dispense_to_location: nil,
      needs_human_review: nil,
      pharmacy_treatment_suppliers_special_dispensing_instructions: DataTypes.Ce,
      actual_strength: nil,
      actual_strength_unit: DataTypes.Ce,
      substance_lot_number: nil,
      substance_expiration_date: DataTypes.Ts,
      substance_manufacturer_name: DataTypes.Ce,
      indication: DataTypes.Ce,
      dispense_package_size: nil,
      dispense_package_size_unit: DataTypes.Ce,
      dispense_package_method: nil
    ]
end
