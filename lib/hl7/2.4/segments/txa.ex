defmodule HL7.V2_4.Segments.TXA do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_txa: nil,
      document_type: nil,
      document_content_presentation: nil,
      activity_date_time: DataTypes.Ts,
      primary_activity_provider_code_name: DataTypes.Xcn,
      origination_date_time: DataTypes.Ts,
      transcription_date_time: DataTypes.Ts,
      edit_date_time: DataTypes.Ts,
      originator_code_name: DataTypes.Xcn,
      assigned_document_authenticator: DataTypes.Xcn,
      transcriptionist_code_name: DataTypes.Xcn,
      unique_document_number: DataTypes.Ei,
      parent_document_number: DataTypes.Ei,
      placer_order_number: DataTypes.Ei,
      filler_order_number: DataTypes.Ei,
      unique_document_file_name: nil,
      document_completion_status: nil,
      document_confidentiality_status: nil,
      document_availability_status: nil,
      document_storage_status: nil,
      document_change_reason: nil,
      authentication_person_time_stamp: DataTypes.Ppn,
      distributed_copies_code_and_name_of_recipients: DataTypes.Xcn
    ]
end
