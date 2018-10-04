defmodule HL7.V2_3.Segments.PRA do
  @moduledoc """
  HL7 segment data structure for "PRA"
  """

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      pra_primary_key_value: nil,
      practioner_group: DataTypes.Ce,
      practioner_category: nil,
      provider_billing: nil,
      specialty: nil,
      practitioner_id_numbers: nil,
      privileges: nil
    ]
end
