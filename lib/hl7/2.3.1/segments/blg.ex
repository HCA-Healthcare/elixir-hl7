defmodule Hl7.V2_3_1.Segments.BLG do
  @moduledoc """
  HL7 segment data structure for "BLG"
  """

  require Logger
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      when_to_charge: DataTypes.Ccd,
      charge_type: nil,
      account_id: DataTypes.Cx
    ]
end
