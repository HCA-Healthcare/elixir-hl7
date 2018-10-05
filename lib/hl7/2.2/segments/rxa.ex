defmodule HL7.V2_2.Segments.RXA do
  @moduledoc false

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
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
      administration_notes: nil,
      administering_provider: nil,
      administered_at_location: nil,
      administered_per_time_unit: nil
    ]
end
