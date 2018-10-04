defmodule HL7.V2_5.Segments.AFF do
  @moduledoc """
  HL7 segment data structure for "AFF"
  """

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_aff: nil,
      professional_organization: DataTypes.Xon,
      professional_organization_address: DataTypes.Xad,
      professional_organization_affiliation_date_range: DataTypes.Dr,
      professional_affiliation_additional_information: nil
    ]
end
