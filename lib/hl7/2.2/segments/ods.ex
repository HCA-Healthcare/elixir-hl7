defmodule Hl7.V2_2.Segments.ODS do
  @moduledoc """
  HL7 segment data structure for "ODS"
  """

  require Logger
  alias Hl7.V2_2.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      type: nil,
      service_period: DataTypes.Ce,
      diet_supplement_or_preference_code: DataTypes.Ce,
      text_instruction: nil
    ]
end
