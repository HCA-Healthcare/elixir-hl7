defmodule Hl7.V2_5_1.Segments.GP2 do
  @moduledoc """
  HL7 segment data structure for "GP2"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      revenue_code: nil,
      number_of_service_units: nil,
      charge: DataTypes.Cp,
      reimbursement_action_code: nil,
      denial_or_rejection_code: nil,
      oce_edit_code: nil,
      ambulatory_payment_classification_code: DataTypes.Ce,
      modifier_edit_code: nil,
      payment_adjustment_code: nil,
      packaging_status_code: nil,
      expected_cms_payment_amount: DataTypes.Cp,
      reimbursement_type_code: nil,
      co_pay_amount: DataTypes.Cp,
      pay_rate_per_service_unit: nil
    ]
end
