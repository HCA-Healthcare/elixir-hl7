defmodule Hl7.V2_5_1.Segments.QPD do
  @moduledoc """
  HL7 segment data structure for "QPD"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      message_query_name: DataTypes.Ce,
      query_tag: nil,
      user_parameters_in_successive_fields: nil
    ]
end
