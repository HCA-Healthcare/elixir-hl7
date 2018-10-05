defmodule HL7.V2_5_1.Segments.BLC do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      blood_product_code: DataTypes.Ce,
      blood_amount: DataTypes.Cq
    ]
end
