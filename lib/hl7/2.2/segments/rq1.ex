defmodule HL7.V2_2.Segments.RQ1 do
  @moduledoc false

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			anticipated_price: nil,
			manufacturer_id: DataTypes.Ce,
			manufacturers_catalog: nil,
			vendor_id: DataTypes.Ce,
			vendor_catalog: nil,
			taxable: nil,
			substitute_allowed: nil
    ]
end
