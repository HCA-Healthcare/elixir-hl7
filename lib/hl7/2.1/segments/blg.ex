defmodule HL7.V2_1.Segments.BLG do
  @moduledoc """
  HL7 segment data structure for "BLG"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      when_to_charge: nil,
      charge_type: nil,
      account_id: nil
    ]
end
