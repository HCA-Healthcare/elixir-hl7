defmodule Hl7.V2_5_1.Segments.BLC do
  @moduledoc """
  HL7 segment data structure for "BLC"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      blood_product_code: DataTypes.Ce,
      blood_amount: DataTypes.Cq
    ]
end
