defmodule Hl7.V2_3_1.Segments.PRD do
  @moduledoc """
  HL7 segment data structure for "PRD"
  """

  require Logger
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      provider_role: DataTypes.Ce,
      provider_name: DataTypes.Xpn,
      provider_address: DataTypes.Xad,
      provider_location: DataTypes.Pl,
      provider_communication_information: DataTypes.Xtn,
      preferred_method_of_contact: DataTypes.Ce,
      provider_identifiers: DataTypes.Pi,
      effective_start_date_of_provider_role: DataTypes.Ts,
      effective_end_date_of_provider_role: DataTypes.Ts
    ]
end
