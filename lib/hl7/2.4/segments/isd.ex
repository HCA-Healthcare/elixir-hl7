defmodule Hl7.V2_4.Segments.ISD do
  @moduledoc """
  HL7 segment data structure for "ISD"
  """

  require Logger
  alias Hl7.V2_4.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      reference_interaction_number_unique_identifier: nil,
      interaction_type_identifier: DataTypes.Ce,
      interaction_active_state: DataTypes.Ce
    ]
end
