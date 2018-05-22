defmodule Hl7.V2_4.Segments.DRG do
  @moduledoc """
  HL7 segment data structure for "DRG"
  """

  require Logger
  alias Hl7.V2_4.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      diagnostic_related_group: DataTypes.Ce,
      drg_assigned_date_time: DataTypes.Ts,
      drg_approval_indicator: nil,
      drg_grouper_review_code: nil,
      outlier_type: DataTypes.Ce,
      outlier_days: nil,
      outlier_cost: DataTypes.Cp,
      drg_payor: nil,
      outlier_reimbursement: DataTypes.Cp,
      confidential_indicator: nil,
      drg_transfer_type: nil
    ]
end
