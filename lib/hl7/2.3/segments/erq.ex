defmodule Hl7.V2_3.Segments.ERQ do
  @moduledoc """
  HL7 segment data structure for "ERQ"
  """

  require Logger
  alias Hl7.V2_3.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      query_tag: nil,
      event_identifier: DataTypes.Ce,
      input_parameter_list: DataTypes.Qip
    ]
end
