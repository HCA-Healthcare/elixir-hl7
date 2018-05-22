defmodule Hl7.V2_5_1.Segments.OBR do
  @moduledoc """
  HL7 segment data structure for "OBR"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_obr: nil,
      placer_order_number: DataTypes.Ei,
      filler_order_number: DataTypes.Ei,
      universal_service_identifier: DataTypes.Ce,
      priority_obr: nil,
      requested_date_time: DataTypes.Ts,
      observation_date_time: DataTypes.Ts,
      observation_end_date_time: DataTypes.Ts,
      collection_volume: DataTypes.Cq,
      collector_identifier: DataTypes.Xcn,
      specimen_action_code: nil,
      danger_code: DataTypes.Ce,
      relevant_clinical_information: nil,
      specimen_received_date_time: DataTypes.Ts,
      specimen_source: DataTypes.Sps,
      ordering_provider: DataTypes.Xcn,
      order_callback_phone_number: DataTypes.Xtn,
      placer_field_1: nil,
      placer_field_2: nil,
      filler_field_1: nil,
      filler_field_2: nil,
      results_rpt_status_chng_date_time: DataTypes.Ts,
      charge_to_practice: DataTypes.Moc,
      diagnostic_serv_sect_id: nil,
      result_status: nil,
      parent_result: DataTypes.Prl,
      quantity_timing: DataTypes.Tq,
      result_copies_to: DataTypes.Xcn,
      parent: DataTypes.Eip,
      transportation_mode: nil,
      reason_for_study: DataTypes.Ce,
      principal_result_interpreter: DataTypes.Ndl,
      assistant_result_interpreter: DataTypes.Ndl,
      technician: DataTypes.Ndl,
      transcriptionist: DataTypes.Ndl,
      scheduled_date_time: DataTypes.Ts,
      number_of_sample_containers_: nil,
      transport_logistics_of_collected_sample: DataTypes.Ce,
      collectors_comment_: DataTypes.Ce,
      transport_arrangement_responsibility: DataTypes.Ce,
      transport_arranged: nil,
      escort_required: nil,
      planned_patient_transport_comment: DataTypes.Ce,
      procedure_code: DataTypes.Ce,
      procedure_code_modifier: DataTypes.Ce,
      placer_supplemental_service_information: DataTypes.Ce,
      filler_supplemental_service_information: DataTypes.Ce,
      medically_necessary_duplicate_procedure_reason: DataTypes.Cwe,
      result_handling: nil,
      parent_universal_service_identifier: DataTypes.Cwe
    ]
end
