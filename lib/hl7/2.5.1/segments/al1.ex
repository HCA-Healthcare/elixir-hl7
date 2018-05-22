defmodule Hl7.V2_5_1.Segments.AL1 do
  @moduledoc """
  HL7 segment data structure for "AL1"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_al1: nil,
      allergen_type_code: DataTypes.Ce,
      allergen_code_mnemonic_description: DataTypes.Ce,
      allergy_severity_code: DataTypes.Ce,
      allergy_reaction_code: nil,
      identification_date: nil
    ]
end
