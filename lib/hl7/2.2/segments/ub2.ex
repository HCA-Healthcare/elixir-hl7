defmodule HL7.V2_2.Segments.UB2 do
  @moduledoc false

  require Logger
  
  use HL7.Segment,
    fields: [
      segment: nil,
			set_id_ub92: nil,
			co_insurance_days_9: nil,
			condition_code_24_30: nil,
			covered_days_7: nil,
			non_covered_days_8: nil,
			value_amount_and_code_39_41: nil,
			occurrence_code_and_date_32_35: nil,
			occurrence_span_code_dates_36: nil,
			ub92_locator_2_state: nil,
			ub92_locator_11_state: nil,
			ub92_locator_31_national: nil,
			document_control_number_37: nil,
			ub92_locator_49_national: nil,
			ub92_locator_56_state: nil,
			ub92_locator_57_national: nil,
			ub92_locator_78_state: nil
    ]
end
