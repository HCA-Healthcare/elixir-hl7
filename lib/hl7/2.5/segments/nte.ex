defmodule HL7.V2_5.Segments.NTE do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_nte: nil,
			source_of_comment: nil,
			comment: nil,
			comment_type: DataTypes.Ce
    ]
end
