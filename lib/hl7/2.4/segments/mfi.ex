defmodule HL7.V2_4.Segments.MFI do
  @moduledoc """
  HL7 segment data structure for "MFI"
  """

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      master_file_identifier: DataTypes.Ce,
      master_file_application_identifier: DataTypes.Hd,
      file_level_event_code: nil,
      entered_date_time: DataTypes.Ts,
      effective_date_time: DataTypes.Ts,
      response_level_code: nil
    ]
end
