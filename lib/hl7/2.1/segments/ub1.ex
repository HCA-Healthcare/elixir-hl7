defmodule HL7.V2_1.Segments.UB1 do
  @moduledoc false

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_ub82: nil,
      blood_deductible: nil,
      blood_furn_pints_of_40: nil,
      blood_replaced_pints_41: nil,
      blood_not_rplcd_pints42: nil,
      co_insurance_days_25: nil,
      condition_code: nil,
      covered_days_23: nil,
      non_covered_days_24: nil,
      value_amount_code: nil,
      number_of_grace_days_90: nil,
      spec_prog_indicator44: nil,
      psro_ur_approval_ind_87: nil,
      psro_ur_aprvd_stay_fm88: nil,
      psro_ur_aprvd_stay_to89: nil,
      occurrence_28_32: nil,
      occurrence_span_33: nil,
      occurrence_span_start_date33: nil,
      occur_span_end_date_33: nil,
      ub_82_locator_2: nil,
      ub_82_locator_9: nil,
      ub_82_locator_27: nil,
      ub_82_locator_45: nil
    ]
end
