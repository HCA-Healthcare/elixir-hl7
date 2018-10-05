defmodule HL7.V2_4.Segments.UB1 do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_ub1: nil,
      blood_deductible_43: nil,
      blood_furnished_pints_of_40: nil,
      blood_replaced_pints_41: nil,
      blood_not_replaced_pints42: nil,
      co_insurance_days_25: nil,
      condition_code_35_39: nil,
      covered_days_23: nil,
      non_covered_days_24: nil,
      value_amount_code_46_49: DataTypes.Uvc,
      number_of_grace_days_90: nil,
      special_program_indicator_44: DataTypes.Ce,
      psro_ur_approval_indicator_87: DataTypes.Ce,
      psro_ur_approved_stay_fm_88: nil,
      psro_ur_approved_stay_to_89: nil,
      occurrence_28_32: DataTypes.Ocd,
      occurrence_span_33: DataTypes.Ce,
      occur_span_start_date33: nil,
      occur_span_end_date_33: nil,
      ub_82_locator_2: nil,
      ub_82_locator_9: nil,
      ub_82_locator_27: nil,
      ub_82_locator_45: nil
    ]
end
