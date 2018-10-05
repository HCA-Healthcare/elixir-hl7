defmodule HL7.V2_5_1.Segments.NSC do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			application_change_type: nil,
			current_cpu: nil,
			current_fileserver: nil,
			current_application: DataTypes.Hd,
			current_facility: DataTypes.Hd,
			new_cpu: nil,
			new_fileserver: nil,
			new_application: DataTypes.Hd,
			new_facility: DataTypes.Hd
    ]
end
