defmodule Hl7.V2_3.Segments.OBR do
  @moduledoc """
  HL7 segment data structure for "OBR"
  """

  require Logger
  alias Hl7.V2_3.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_observation_request: nil,
      placer_order_number: DataTypes.Ei,
      filler_order_number: DataTypes.Ei,
      universal_service_identifier: DataTypes.Ce,
      priority: nil,
      requested_date_time: DataTypes.Ts,
      observation_date_time: DataTypes.Ts,
      observation_end_date_time: DataTypes.Ts,
      collection_volume: DataTypes.Cq,
      collector_identifier: DataTypes.Xcn,
      specimen_action_code: nil,
      danger_code: DataTypes.Ce,
      relevant_clinical_information: nil,
      specimen_received_date_time: DataTypes.Ts,
      specimen_source: nil,
      ordering_provider: DataTypes.Xcn,
      order_callback_phone_number: DataTypes.Xtn,
      placer_field_1: nil,
      placer_field_2: nil,
      filler_field_1: nil,
      filler_field_2: nil,
      results_rpt_status_chng_date_time: DataTypes.Ts,
      charge_to_practice: nil,
      diagnostic_service_section_id: nil,
      result_status: nil,
      parent_result: nil,
      quantity_timing: DataTypes.Tq,
      result_copies_to: DataTypes.Xcn,
      parent_number: nil,
      transportation_mode: nil,
      reason_for_study: DataTypes.Ce,
      principal_result_interpreter: nil,
      assistant_result_interpreter: nil,
      technician: nil,
      transcriptionist: nil,
      scheduled_date_time: DataTypes.Ts,
      number_of_sample_containers: nil,
      transport_logistics_of_collected_sample: DataTypes.Ce,
      collectors_comment: DataTypes.Ce,
      transport_arrangement_responsibility: DataTypes.Ce,
      transport_arranged: nil,
      escort_required: nil,
      planned_patient_transport_comment: DataTypes.Ce
    ]
end
