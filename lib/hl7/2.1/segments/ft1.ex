defmodule HL7.V2_1.Segments.FT1 do
  @moduledoc """
  HL7 segment data structure for "FT1"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_financial_transaction: nil,
      transaction_id: nil,
      transaction_batch_id: nil,
      transaction_date: nil,
      transaction_posting_date: nil,
      transaction_type: nil,
      transaction_code: nil,
      transaction_description: nil,
      transaction_description_alt: nil,
      transaction_amount_extended: nil,
      transaction_quantity: nil,
      transaction_amount_unit: nil,
      department_code: nil,
      insurance_plan_id: nil,
      insurance_amount: nil,
      patient_location: nil,
      fee_schedule: nil,
      patient_type: nil,
      diagnosis_code: nil,
      performed_by_code: nil,
      ordered_by_code: nil,
      unit_cost: nil
    ]
end
