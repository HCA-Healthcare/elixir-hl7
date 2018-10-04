defmodule HL7.V2_3_1.Segments.UB2 do
  @moduledoc """
  HL7 segment data structure for "UB2"
  """

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_ub2: nil,
      co_insurance_days_9: nil,
      condition_code_24_30: nil,
      covered_days_7: nil,
      non_covered_days_8: nil,
      value_amount_code: DataTypes.Uvc,
      occurrence_code_date_32_35: DataTypes.Ocd,
      occurrence_span_code_dates_36: DataTypes.Osp,
      ub92_locator_2_state: nil,
      ub92_locator_11_state: nil,
      ub92_locator_31_national: nil,
      document_control_number: nil,
      ub92_locator_49_national: nil,
      ub92_locator_56_state: nil,
      ub92_locator_57_national: nil,
      ub92_locator_78_state: nil,
      special_visit_count: nil
    ]
end
