defmodule HL7.V2_5_1.Segments.MFI do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

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
