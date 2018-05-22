defmodule Hl7.V2_5.Segments.BHS do
  @moduledoc """
  HL7 segment data structure for "BHS"
  """

  require Logger
  alias Hl7.V2_5.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      batch_field_separator: nil,
      batch_encoding_characters: nil,
      batch_sending_application: DataTypes.Hd,
      batch_sending_facility: DataTypes.Hd,
      batch_receiving_application: DataTypes.Hd,
      batch_receiving_facility: DataTypes.Hd,
      batch_creation_date_time: DataTypes.Ts,
      batch_security: nil,
      batch_name_id_type: nil,
      batch_comment: nil,
      batch_control_id: nil,
      reference_batch_control_id: nil
    ]
end
