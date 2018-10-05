defmodule HL7.V2_3_1.Segments.PSH do
  @moduledoc false

  require Logger
  alias HL7.V2_3_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      report_type: nil,
      report_form_identifier: nil,
      report_date: DataTypes.Ts,
      report_interval_start_date: DataTypes.Ts,
      report_interval_end_date: DataTypes.Ts,
      quantity_manufactured: DataTypes.Cq,
      quantity_distributed: DataTypes.Cq,
      quantity_distributed_method: nil,
      quantity_distributed_comment: nil,
      quantity_in_use: DataTypes.Cq,
      quantity_in_use_method: nil,
      quantity_in_use_comment: nil,
      number_of_product_experience_reports_filed_by_facility: nil,
      number_of_product_experience_reports_filed_by_distributor: nil
    ]
end
