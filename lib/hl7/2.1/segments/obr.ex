defmodule HL7.V2_1.Segments.OBR do
  @moduledoc false

  require Logger
  alias HL7.V2_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_observation_request: nil,
      placer_order_: nil,
      filler_order_: nil,
      universal_service_ident: DataTypes.Ce,
      priority: nil,
      requested_date_time: nil,
      observation_date_time: nil,
      observation_end_date_time: nil,
      collection_volume: nil,
      collector_identifier: nil,
      specimen_action_code: nil,
      danger_code: nil,
      relevant_clinical_info: nil,
      specimen_received_date_time: nil,
      specimen_source: nil,
      ordering_provider: nil,
      order_call_back_phone_num: nil,
      placers_field_1: nil,
      placers_field_2: nil,
      fillers_field_1: nil,
      fillers_field_2: nil,
      results_rpt_status_chng_date_t: nil,
      charge_to_practice: nil,
      diagnostic_serv_sect_id: nil,
      result_status: nil,
      linked_results: DataTypes.Ce,
      quantity_timing: nil,
      result_copies_to: nil,
      parent_accession_: nil,
      transportation_mode: nil,
      reason_for_study: DataTypes.Ce,
      principal_result_interpreter: nil,
      assistant_result_interpreter: nil,
      technician: nil,
      transcriptionist: nil,
      scheduled_date_time: nil
    ]
end
