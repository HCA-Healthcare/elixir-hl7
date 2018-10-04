defmodule HL7.V2_5_1.Segments.SPM do
  @moduledoc """
  HL7 segment data structure for "SPM"
  """

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_spm: nil,
      specimen_id: DataTypes.Eip,
      specimen_parent_ids: DataTypes.Eip,
      specimen_type: DataTypes.Cwe,
      specimen_type_modifier: DataTypes.Cwe,
      specimen_additives: DataTypes.Cwe,
      specimen_collection_method: DataTypes.Cwe,
      specimen_source_site: DataTypes.Cwe,
      specimen_source_site_modifier: DataTypes.Cwe,
      specimen_collection_site: DataTypes.Cwe,
      specimen_role: DataTypes.Cwe,
      specimen_collection_amount: DataTypes.Cq,
      grouped_specimen_count: nil,
      specimen_description: nil,
      specimen_handling_code: DataTypes.Cwe,
      specimen_risk_code: DataTypes.Cwe,
      specimen_collection_date_time: DataTypes.Dr,
      specimen_received_date_time: DataTypes.Ts,
      specimen_expiration_date_time: DataTypes.Ts,
      specimen_availability: nil,
      specimen_reject_reason: DataTypes.Cwe,
      specimen_quality: DataTypes.Cwe,
      specimen_appropriateness: DataTypes.Cwe,
      specimen_condition: DataTypes.Cwe,
      specimen_current_quantity: DataTypes.Cq,
      number_of_specimen_containers: nil,
      container_type: DataTypes.Cwe,
      container_condition: DataTypes.Cwe,
      specimen_child_role: DataTypes.Cwe
    ]
end
