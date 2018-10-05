defmodule HL7.V2_2.Segments.BLG do
  @moduledoc false

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      when_to_charge: nil,
      charge_type: nil,
      account_id: nil
    ]
end
