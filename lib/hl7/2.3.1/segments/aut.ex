defmodule Hl7.V2_3_1.Segments.AUT do
  @moduledoc """
  HL7 segment data structure for "AUT"
  """

  require Logger
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.Segment,
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
