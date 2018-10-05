defmodule HL7.V2_3.Segments.EQL do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			query_tag: nil,
			query_response_format_code: nil,
			eql_query_name: DataTypes.Ce,
			eql_query_statement: nil
    ]
end
