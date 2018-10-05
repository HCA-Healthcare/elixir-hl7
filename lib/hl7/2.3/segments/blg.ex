defmodule HL7.V2_3.Segments.BLG do
  @moduledoc false

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			when_to_charge: nil,
			charge_type: nil,
			account_id: DataTypes.Ck
    ]
end
