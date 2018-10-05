defmodule HL7.V2_4.Segments.VAR do
  @moduledoc false

  require Logger
  alias HL7.V2_4.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      variance_instance_id: DataTypes.Ei,
      documented_date_time: DataTypes.Ts,
      stated_variance_date_time: DataTypes.Ts,
      variance_originator: DataTypes.Xcn,
      variance_classification: DataTypes.Ce,
      variance_description: nil
    ]
end
