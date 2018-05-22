defmodule Hl7.V2_2.Segments.PRA do
  @moduledoc """
  HL7 segment data structure for "PRA"
  """

  require Logger
  alias Hl7.V2_2.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      pra_primary_key_value: nil,
      practitioner_group: DataTypes.Ce,
      practitioner_category: nil,
      provider_billing: nil,
      specialty: nil,
      practitioner_id_numbers: nil,
      privileges: nil
    ]
end
