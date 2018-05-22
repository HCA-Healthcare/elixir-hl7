defmodule Hl7.V2_3.Segments.FT1 do
  @moduledoc """
  HL7 segment data structure for "FT1"
  """

  require Logger
  alias Hl7.V2_3.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_financial_transaction: nil,
      transaction_id: nil,
      transaction_batch_id: nil,
      transaction_date: DataTypes.Ts,
      transaction_posting_date: DataTypes.Ts,
      transaction_type: nil,
      transaction_code: DataTypes.Ce,
      transaction_description: nil,
      transaction_description_alternate: nil,
      transaction_quantity: nil,
      transaction_amount_extended: DataTypes.Cp,
      transaction_amount_unit: DataTypes.Cp,
      department_code: DataTypes.Ce,
      insurance_plan_id: DataTypes.Ce,
      insurance_amount: DataTypes.Cp,
      assigned_patient_location: DataTypes.Pl,
      fee_schedule: nil,
      patient_type: nil,
      diagnosis_code: DataTypes.Ce,
      performed_by_code: DataTypes.Xcn,
      ordered_by_code: DataTypes.Xcn,
      unit_cost: nil,
      filler_order_number: DataTypes.Ei,
      entered_by_code: DataTypes.Xcn,
      procedure_code: DataTypes.Ce
    ]
end
