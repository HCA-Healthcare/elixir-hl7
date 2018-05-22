defmodule Hl7.V2_2.Segments.RXG do
  @moduledoc """
  HL7 segment data structure for "RXG"
  """

  require Logger
  alias Hl7.V2_2.{DataTypes}

  use Hl7.Segment,
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
      administration_notes: nil,
      substitution_status: nil,
      deliver_to_location: nil,
      needs_human_review: nil,
      pharmacy_special_administration_instructions: DataTypes.Ce,
      give_per_time_unit: nil,
      give_rate_amount: DataTypes.Ce,
      give_rate_units: DataTypes.Ce
    ]
end
