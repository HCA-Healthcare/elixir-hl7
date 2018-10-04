defmodule HL7.V2_4.Segments.OM7 do
  @moduledoc """
  HL7 segment data structure for "OM7"
  """

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      sequence_number_test_observation_master_file: nil,
      universal_service_identifier: DataTypes.Ce,
      category_identifier: DataTypes.Ce,
      category_description: nil,
      category_synonym: nil,
      effective_test_service_start_date_time: DataTypes.Ts,
      effective_test_service_end_date_time: DataTypes.Ts,
      test_service_default_duration_quantity: nil,
      test_service_default_duration_units: DataTypes.Ce,
      test_service_default_frequency: nil,
      consent_indicator: nil,
      consent_identifier: DataTypes.Ce,
      consent_effective_start_date_time: DataTypes.Ts,
      consent_effective_end_date_time: DataTypes.Ts,
      consent_interval_quantity: nil,
      consent_interval_units: DataTypes.Ce,
      consent_waiting_period_quantity: nil,
      consent_waiting_period_units: DataTypes.Ce,
      effective_date_time_of_change: DataTypes.Ts,
      entered_by: DataTypes.Xcn,
      orderable_at_location: DataTypes.Pl,
      formulary_status: nil,
      special_order_indicator: nil,
      primary_key_value_cdm: DataTypes.Ce
    ]
end
