defmodule HL7.V2_5_1.Segments.RXD do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

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
			dispensing_provider: DataTypes.Xcn,
			substitution_status: nil,
			total_daily_dose: DataTypes.Cq,
			dispense_to_location: DataTypes.La2,
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
			dispense_package_method: nil,
			supplementary_code: DataTypes.Ce,
			initiating_location: DataTypes.Ce,
			packaging_assembly_location: DataTypes.Ce,
			actual_drug_strength_volume: nil,
			actual_drug_strength_volume_units: DataTypes.Cwe,
			dispense_to_pharmacy: DataTypes.Cwe,
			dispense_to_pharmacy_address: DataTypes.Xad,
			pharmacy_order_type: nil,
			dispense_type: DataTypes.Cwe
    ]
end
