defmodule HL7.V2_5.Segments.RQD do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      requisition_line_number: nil,
      item_code_internal: DataTypes.Ce,
      item_code_external: DataTypes.Ce,
      hospital_item_code: DataTypes.Ce,
      requisition_quantity: nil,
      requisition_unit_of_measure: DataTypes.Ce,
      dept_cost_center: nil,
      item_natural_account_code: nil,
      deliver_to_id: DataTypes.Ce,
      date_needed: nil
    ]
end
