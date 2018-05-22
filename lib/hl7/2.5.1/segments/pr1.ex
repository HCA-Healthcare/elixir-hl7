defmodule Hl7.V2_5_1.Segments.PR1 do
  @moduledoc """
  HL7 segment data structure for "PR1"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      set_id_pr1: nil,
      procedure_coding_method: nil,
      procedure_code: DataTypes.Ce,
      procedure_description: nil,
      procedure_date_time: DataTypes.Ts,
      procedure_functional_type: nil,
      procedure_minutes: nil,
      anesthesiologist: DataTypes.Xcn,
      anesthesia_code: nil,
      anesthesia_minutes: nil,
      surgeon: DataTypes.Xcn,
      procedure_practitioner: DataTypes.Xcn,
      consent_code: DataTypes.Ce,
      procedure_priority: nil,
      associated_diagnosis_code: DataTypes.Ce,
      procedure_code_modifier: DataTypes.Ce,
      procedure_drg_type: nil,
      tissue_type_code: DataTypes.Ce,
      procedure_identifier: DataTypes.Ei,
      procedure_action_code: nil
    ]
end
