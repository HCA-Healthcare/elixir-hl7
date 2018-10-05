defmodule HL7.V2_5_1.Segments.AUT do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			authorizing_payor_plan_id: DataTypes.Ce,
			authorizing_payor_company_id: DataTypes.Ce,
			authorizing_payor_company_name: nil,
			authorization_effective_date: DataTypes.Ts,
			authorization_expiration_date: DataTypes.Ts,
			authorization_identifier: DataTypes.Ei,
			reimbursement_limit: DataTypes.Cp,
			requested_number_of_treatments: nil,
			authorized_number_of_treatments: nil,
			process_date: DataTypes.Ts
    ]
end
