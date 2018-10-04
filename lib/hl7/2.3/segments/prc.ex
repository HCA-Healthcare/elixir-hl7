defmodule HL7.V2_3.Segments.PRC do
  @moduledoc """
  HL7 segment data structure for "PRC"
  """

  require Logger
  alias HL7.V2_3.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      primary_key_value: DataTypes.Ce,
      facility_id: DataTypes.Ei,
      department: DataTypes.Ce,
      valid_patient_classes: nil,
      price: DataTypes.Cp,
      formula: nil,
      minimum_quantity: nil,
      maximum_quantity: nil,
      minimum_price: DataTypes.Mo,
      maximum_price: DataTypes.Mo,
      effective_start_date: DataTypes.Ts,
      effective_end_date: DataTypes.Ts,
      price_override_flag: nil,
      billing_category: DataTypes.Ce,
      chargeable_flag: nil,
      active_inactive_flag: nil,
      cost: DataTypes.Mo,
      charge_on_indicator: nil
    ]
end
