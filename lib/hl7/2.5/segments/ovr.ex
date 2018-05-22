defmodule Hl7.V2_5.Segments.OVR do
  @moduledoc """
  HL7 segment data structure for "OVR"
  """

  require Logger
  alias Hl7.V2_5.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      business_rule_override_type: DataTypes.Cwe,
      business_rule_override_code: DataTypes.Cwe,
      override_comments: nil,
      override_entered_by: DataTypes.Xcn,
      override_authorized_by: DataTypes.Xcn
    ]
end
