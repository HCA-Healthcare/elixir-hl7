defmodule Hl7.V2_2.Segments.BLG do
  @moduledoc """
  HL7 segment data structure for "BLG"
  """

  require Logger

  use Hl7.Segment,
    fields: [
      segment: nil,
      when_to_charge: nil,
      charge_type: nil,
      account_id: nil
    ]
end
