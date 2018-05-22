defmodule Hl7.V2_3.Segments.BLG do
  @moduledoc """
  HL7 segment data structure for "BLG"
  """

  require Logger
  alias Hl7.V2_3.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      when_to_charge: nil,
      charge_type: nil,
      account_id: DataTypes.Ck
    ]
end
