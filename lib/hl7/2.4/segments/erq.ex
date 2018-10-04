defmodule HL7.V2_4.Segments.ERQ do
  @moduledoc """
  HL7 segment data structure for "ERQ"
  """

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      query_tag: nil,
      event_identifier: DataTypes.Ce,
      input_parameter_list: DataTypes.Qip
    ]
end
