defmodule HL7.V2_1.Segments.ORO do
  @moduledoc false

  require Logger
  alias HL7.V2_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			order_item_id: DataTypes.Ce,
			substitute_allowed: nil,
			results_copies_to: nil,
			stock_location: nil
    ]
end
