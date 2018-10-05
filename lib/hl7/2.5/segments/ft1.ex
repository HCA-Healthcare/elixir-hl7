defmodule HL7.V2_5.Segments.FT1 do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_ft1: nil,
      transaction_id: nil,
      transaction_batch_id: nil,
      transaction_date: DataTypes.Dr,
      transaction_posting_date: DataTypes.Ts,
      transaction_type: nil,
      transaction_code: DataTypes.Ce,
      transaction_description: nil,
      transaction_description_alt: nil,
      transaction_quantity: nil,
      transaction_amount_extended: DataTypes.Cp,
      transaction_amount_unit: DataTypes.Cp,
      department_code: DataTypes.Ce,
      insurance_plan_id: DataTypes.Ce,
      insurance_amount: DataTypes.Cp,
      assigned_patient_location: DataTypes.Pl,
      fee_schedule: nil,
      patient_type: nil,
      diagnosis_code_ft1: DataTypes.Ce,
      performed_by_code: DataTypes.Xcn,
      ordered_by_code: DataTypes.Xcn,
      unit_cost: DataTypes.Cp,
      filler_order_number: DataTypes.Ei,
      entered_by_code: DataTypes.Xcn,
      procedure_code: DataTypes.Ce,
      procedure_code_modifier: DataTypes.Ce,
      advanced_beneficiary_notice_code: DataTypes.Ce,
      medically_necessary_duplicate_procedure_reason: DataTypes.Cwe,
      ndc_code: DataTypes.Cne,
      payment_reference_id: DataTypes.Cx,
      transaction_reference_key: nil
    ]
end
