defmodule Hl7.V2_5.Segments.RDF do
  @moduledoc """
  HL7 segment data structure for "RDF"
  """

  require Logger
  alias Hl7.V2_5.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      number_of_columns_per_row: nil,
      column_description: DataTypes.Rcd
    ]
end
