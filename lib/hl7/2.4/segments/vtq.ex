defmodule HL7.V2_4.Segments.VTQ do
  @moduledoc """
  HL7 segment data structure for "VTQ"
  """

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      query_tag: nil,
      query_response_format_code: nil,
      vt_query_name: DataTypes.Ce,
      virtual_table_name: DataTypes.Ce,
      selection_criteria: DataTypes.Qsc
    ]
end
