defmodule Hl7.V2_1.Segments.ORO do
  @moduledoc """
  HL7 segment data structure for "ORO"
  """

  require Logger
  alias Hl7.V2_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      order_item_id: DataTypes.Ce,
      substitute_allowed: nil,
      results_copies_to: nil,
      stock_location: nil
    ]
end
