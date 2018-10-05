defmodule HL7.V2_5.Segments.SID do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      application_method_identifier: DataTypes.Ce,
      substance_lot_number: nil,
      substance_container_identifier: nil,
      substance_manufacturer_identifier: DataTypes.Ce
    ]
end
