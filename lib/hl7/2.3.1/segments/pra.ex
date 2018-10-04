defmodule HL7.V2_3_1.Segments.PRA do
  @moduledoc """
  HL7 segment data structure for "PRA"
  """

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      primary_key_value_pra: DataTypes.Ce,
      practitioner_group: DataTypes.Ce,
      practitioner_category: nil,
      provider_billing: nil,
      specialty: DataTypes.Spd,
      practitioner_id_numbers: DataTypes.Pln,
      privileges: DataTypes.Pip,
      date_entered_practice: nil
    ]
end
