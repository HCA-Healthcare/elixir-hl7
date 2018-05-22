defmodule Hl7.V2_2.Segments.OBR do
  @moduledoc """
  HL7 segment data structure for "OBR"
  """

  require Logger
  alias Hl7.V2_2.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_observation_request: nil,
      placer_order_number: nil,
      filler_order_number: nil,
      universal_service_id: DataTypes.Ce,
      priority_not_used: nil,
      requested_date_time_not_used: DataTypes.Ts,
      observation_date_time: DataTypes.Ts,
      observation_end_date_time: DataTypes.Ts,
      collection_volume: nil,
      collector_identifier: nil,
      specimen_action_code: nil,
      danger_code: DataTypes.Ce,
      relevant_clinical_information: nil,
      specimen_received_date_time: DataTypes.Ts,
      specimen_source: nil,
      ordering_provider: nil,
      order_callback_phone_number: nil,
      placer_field_1: nil,
      placer_field_2: nil,
      filler_field_1: nil,
      filler_field_2: nil,
      results_report_status_change_date_time: DataTypes.Ts,
      charge_to_practice: nil,
      diagnostic_service_section_id: nil,
      result_status: nil,
      parent_result: nil,
      quantity_timing: DataTypes.Tq,
      result_copies_to: nil,
      parent_number: nil,
      transportation_mode: nil,
      reason_for_study: DataTypes.Ce,
      principal_result_interpreter: nil,
      assistant_result_interpreter: nil,
      technician: nil,
      transcriptionist: nil,
      scheduled_date_time: DataTypes.Ts
    ]
end
