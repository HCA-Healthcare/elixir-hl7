defmodule Hl7.V2_5_1.Segments.PRA do
  @moduledoc """
  HL7 segment data structure for "PRA"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      primary_key_value_pra: DataTypes.Ce,
      practitioner_group: DataTypes.Ce,
      practitioner_category: nil,
      provider_billing: nil,
      specialty: DataTypes.Spd,
      practitioner_id_numbers: DataTypes.Pln,
      privileges: DataTypes.Pip,
      date_entered_practice: nil,
      institution: DataTypes.Ce,
      date_left_practice: nil,
      government_reimbursement_billing_eligibility: DataTypes.Ce,
      set_id_pra: nil
    ]
end
