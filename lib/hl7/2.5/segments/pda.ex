defmodule Hl7.V2_5.Segments.PDA do
  @moduledoc """
  HL7 segment data structure for "PDA"
  """

  require Logger
  alias Hl7.V2_5.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      death_cause_code: DataTypes.Ce,
      death_location: DataTypes.Pl,
      death_certified_indicator: nil,
      death_certificate_signed_date_time: DataTypes.Ts,
      death_certified_by: DataTypes.Xcn,
      autopsy_indicator: nil,
      autopsy_start_and_end_date_time: DataTypes.Dr,
      autopsy_performed_by: DataTypes.Xcn,
      coroner_indicator: nil
    ]
end
