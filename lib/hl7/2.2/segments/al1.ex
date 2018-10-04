defmodule HL7.V2_2.Segments.AL1 do
  @moduledoc """
  HL7 segment data structure for "AL1"
  """

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_allergy: nil,
      allergy_type: nil,
      allergy_code_mnemonic_description: DataTypes.Ce,
      allergy_severity: nil,
      allergy_reaction: nil,
      identification_date: nil
    ]
end
