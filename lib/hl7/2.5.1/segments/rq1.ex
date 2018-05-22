defmodule Hl7.V2_5_1.Segments.RQ1 do
  @moduledoc """
  HL7 segment data structure for "RQ1"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      anticipated_price: nil,
      manufacturer_identifier: DataTypes.Ce,
      manufacturers_catalog: nil,
      vendor_id: DataTypes.Ce,
      vendor_catalog: nil,
      taxable: nil,
      substitute_allowed: nil
    ]
end
