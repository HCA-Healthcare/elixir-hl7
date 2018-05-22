defmodule Hl7.V2_5_1.Segments.FAC do
  @moduledoc """
  HL7 segment data structure for "FAC"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      facility_id_fac: DataTypes.Ei,
      facility_type: nil,
      facility_address: DataTypes.Xad,
      facility_telecommunication: DataTypes.Xtn,
      contact_person: DataTypes.Xcn,
      contact_title: nil,
      contact_address: DataTypes.Xad,
      contact_telecommunication: DataTypes.Xtn,
      signature_authority: DataTypes.Xcn,
      signature_authority_title: nil,
      signature_authority_address: DataTypes.Xad,
      signature_authority_telecommunication: DataTypes.Xtn
    ]
end
