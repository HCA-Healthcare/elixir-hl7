defmodule Hl7.V2_3.Segments.RXO do
  @moduledoc """
  HL7 segment data structure for "RXO"
  """

  require Logger
  alias Hl7.V2_3.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      requested_give_code: DataTypes.Ce,
      requested_give_amount_minimum: nil,
      requested_give_amount_maximum: nil,
      requested_give_units: DataTypes.Ce,
      requested_dosage_form: DataTypes.Ce,
      providers_pharmacy_instructions: DataTypes.Ce,
      providers_administration_instructions: DataTypes.Ce,
      deliver_to_location: nil,
      allow_substitutions: nil,
      requested_dispense_code: DataTypes.Ce,
      requested_dispense_amount: nil,
      requested_dispense_units: DataTypes.Ce,
      number_of_refills: nil,
      ordering_providers_dea_number: DataTypes.Cn,
      pharmacist_treatment_suppliers_verifier_id: DataTypes.Cn,
      needs_human_review: nil,
      requested_give_per_time_unit: nil,
      requested_give_strength: nil,
      requested_give_strength_units: DataTypes.Ce,
      indication: DataTypes.Ce,
      requested_give_rate_amount: nil,
      requested_give_rate_units: DataTypes.Ce
    ]
end
