defmodule Hl7.V2_5.Segments.VAR do
  @moduledoc """
  HL7 segment data structure for "VAR"
  """

  require Logger
  alias Hl7.V2_5.{DataTypes}

  use Hl7.Segment,
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
