defmodule HL7.V2_3.Segments.ERQ do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			query_tag: nil,
			event_identifier: DataTypes.Ce,
			input_parameter_list: DataTypes.Qip
    ]
end
