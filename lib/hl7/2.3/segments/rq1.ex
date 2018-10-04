defmodule HL7.V2_3.Segments.RQ1 do
  @moduledoc """
  HL7 segment data structure for "RQ1"
  """

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      anticipated_price: nil,
      manufactured_id: DataTypes.Ce,
      manufacturers_catalog: nil,
      vendor_id: DataTypes.Ce,
      vendor_catalog: nil,
      taxable: nil,
      substitute_allowed: nil
    ]
end
