defmodule Hl7.V2_4.Segments.OBR do
  @moduledoc """
  HL7 segment data structure for "OBR"
  """

  require Logger
  alias Hl7.V2_4.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_obr: nil,
      placer_order_number: DataTypes.Ei,
      filler_order_number: DataTypes.Ei,
      universal_service_identifier: DataTypes.Ce,
      priority: nil,
      requested_date_time: DataTypes.Ts,
      observation_date_time_: DataTypes.Ts,
      observation_end_date_time_: DataTypes.Ts,
      collection_volume_: DataTypes.Cq,
      collector_identifier_: DataTypes.Xcn,
      specimen_action_code_: nil,
      danger_code: DataTypes.Ce,
      relevant_clinical_info: nil,
      specimen_received_date_time_: DataTypes.Ts,
      specimen_source: DataTypes.Sps,
      ordering_provider: DataTypes.Xcn,
      order_callback_phone_number: DataTypes.Xtn,
      placer_field_1: nil,
      placer_field_2: nil,
      filler_field_1_: nil,
      filler_field_2_: nil,
      results_rpt_status_chng_date_time_: DataTypes.Ts,
      charge_to_practice_: DataTypes.Moc,
      diagnostic_serv_sect_id: nil,
      result_status_: nil,
      parent_result_: DataTypes.Prl,
      quantity_timing: DataTypes.Tq,
      result_copies_to: DataTypes.Xcn,
      parent: DataTypes.Eip,
      transportation_mode: nil,
      reason_for_study: DataTypes.Ce,
      principal_result_interpreter_: DataTypes.Ndl,
      assistant_result_interpreter_: DataTypes.Ndl,
      technician_: DataTypes.Ndl,
      transcriptionist_: DataTypes.Ndl,
      scheduled_date_time_: DataTypes.Ts,
      number_of_sample_containers_: nil,
      transport_logistics_of_collected_sample_: DataTypes.Ce,
      collectors_comment_: DataTypes.Ce,
      transport_arrangement_responsibility: DataTypes.Ce,
      transport_arranged: nil,
      escort_required: nil,
      planned_patient_transport_comment: DataTypes.Ce,
      procedure_code: DataTypes.Ce,
      procedure_code_modifier: DataTypes.Ce,
      placer_supplemental_service_information: DataTypes.Ce,
      filler_supplemental_service_information: DataTypes.Ce
    ]
end
