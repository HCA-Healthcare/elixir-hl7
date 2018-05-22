defmodule Hl7.V2_5.Segments.TCC do
  @moduledoc """
  HL7 segment data structure for "TCC"
  """

  require Logger
  alias Hl7.V2_5.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      universal_service_identifier: DataTypes.Ce,
      test_application_identifier: DataTypes.Ei,
      specimen_source: DataTypes.Sps,
      auto_dilution_factor_default: DataTypes.Sn,
      rerun_dilution_factor_default: DataTypes.Sn,
      pre_dilution_factor_default: DataTypes.Sn,
      endogenous_content_of_pre_dilution_diluent: DataTypes.Sn,
      inventory_limits_warning_level: nil,
      automatic_rerun_allowed: nil,
      automatic_repeat_allowed: nil,
      automatic_reflex_allowed: nil,
      equipment_dynamic_range: DataTypes.Sn,
      units: DataTypes.Ce,
      processing_type: DataTypes.Ce
    ]
end
