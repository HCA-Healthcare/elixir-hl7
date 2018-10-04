defmodule HL7.V2_5.Segments.LAN do
  @moduledoc """
  HL7 segment data structure for "LAN"
  """

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_lan: nil,
      language_code: DataTypes.Ce,
      language_ability_code: DataTypes.Ce,
      language_proficiency_code: DataTypes.Ce
    ]
end
