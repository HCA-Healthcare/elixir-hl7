defmodule HL7.V2_5_1.Segments.QRI do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			candidate_confidence: nil,
			match_reason_code: nil,
			algorithm_descriptor: DataTypes.Ce
    ]
end
