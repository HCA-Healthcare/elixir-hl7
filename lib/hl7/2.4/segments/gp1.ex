defmodule HL7.V2_4.Segments.GP1 do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			type_of_bill_code: nil,
			revenue_code: nil,
			overall_claim_disposition_code: nil,
			oce_edits_per_visit_code: nil,
			outlier_cost: DataTypes.Cp
    ]
end
