defmodule Hl7.V2_4.Segments.RXA do
  @moduledoc """
  HL7 segment data structure for "RXA"
  """

  require Logger
  alias Hl7.V2_4.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      give_sub_id_counter: nil,
      administration_sub_id_counter: nil,
      date_time_start_of_administration: DataTypes.Ts,
      date_time_end_of_administration: DataTypes.Ts,
      administered_code: DataTypes.Ce,
      administered_amount: nil,
      administered_units: DataTypes.Ce,
      administered_dosage_form: DataTypes.Ce,
      administration_notes: DataTypes.Ce,
      administering_provider: DataTypes.Xcn,
      administered_at_location: DataTypes.La2,
      administered_per_time_unit: nil,
      administered_strength: nil,
      administered_strength_units: DataTypes.Ce,
      substance_lot_number: nil,
      substance_expiration_date: DataTypes.Ts,
      substance_manufacturer_name: DataTypes.Ce,
      substance_treatment_refusal_reason: DataTypes.Ce,
      indication: DataTypes.Ce,
      completion_status: nil,
      action_code_rxa: nil,
      system_entry_date_time: DataTypes.Ts
    ]
end
