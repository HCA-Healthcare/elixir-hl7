defmodule HL7.V2_3_1.Segments.SPR do
  @moduledoc """
  HL7 segment data structure for "SPR"
  """

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      query_tag: nil,
      query_response_format_code: nil,
      stored_procedure_name: DataTypes.Ce,
      input_parameter_list: DataTypes.Qip
    ]
end
