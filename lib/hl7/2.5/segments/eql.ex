defmodule Hl7.V2_5.Segments.EQL do
  @moduledoc """
  HL7 segment data structure for "EQL"
  """

  require Logger
  alias Hl7.V2_5.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      query_tag: nil,
      query_response_format_code: nil,
      eql_query_name: DataTypes.Ce,
      eql_query_statement: nil
    ]
end
