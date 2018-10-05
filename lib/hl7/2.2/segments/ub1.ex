defmodule HL7.V2_2.Segments.UB1 do
  @moduledoc false

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_ub82: nil,
      blood_deductible_43: nil,
      blood_furnished_pints_of_40: nil,
      blood_replaced_pints_41: nil,
      blood_not_replaced_pints_42: nil,
      co_insurance_days_25: nil,
      condition_code_35_39: nil,
      covered_days_23: nil,
      non_covered_days_24: nil,
      value_amount_and_code_46_49: nil,
      number_of_grace_days_90: nil,
      special_program_indicator_44: nil,
      psro_ur_approval_indicator_87: nil,
      psro_ur_approved_stay_from_88: nil,
      psro_ur_approved_stay_to_89: nil,
      occurrence_28_32: nil,
      occurrence_span_33: nil,
      occurrence_span_start_date_33: nil,
      occurrence_span_end_date_33: nil,
      ub_82_locator_2: nil,
      ub_82_locator_9: nil,
      ub_82_locator_27: nil,
      ub_82_locator_45: nil
    ]
end
