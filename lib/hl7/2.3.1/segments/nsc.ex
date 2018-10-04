defmodule HL7.V2_3_1.Segments.NSC do
  @moduledoc """
  HL7 segment data structure for "NSC"
  """

  require Logger

  use HL7.Segment,
    fields: [
      segment: nil,
      network_change_type: nil,
      current_cpu: nil,
      current_fileserver: nil,
      current_application: nil,
      current_facility: nil,
      new_cpu: nil,
      new_fileserver: nil,
      new_application: nil,
      new_facility: nil
    ]
end
