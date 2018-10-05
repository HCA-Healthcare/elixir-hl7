defmodule HL7.V2_2.Segments.FT1 do
  @moduledoc false

  require Logger
  alias HL7.V2_2.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_financial_transaction: nil,
      transaction_id: nil,
      transaction_batch_id: nil,
      transaction_date: nil,
      transaction_posting_date: nil,
      transaction_type: nil,
      transaction_code: DataTypes.Ce,
      transaction_description: nil,
      transaction_description_alternate: nil,
      transaction_quantity: nil,
      transaction_amount_extended: nil,
      transaction_amount_unit: nil,
      department_code: DataTypes.Ce,
      insurance_plan_id: nil,
      insurance_amount: nil,
      assigned_patient_location: nil,
      fee_schedule: nil,
      patient_type: nil,
      diagnosis_code: DataTypes.Ce,
      performed_by_code: nil,
      ordered_by_code: nil,
      unit_cost: nil,
      filler_order_number: nil
    ]
end
