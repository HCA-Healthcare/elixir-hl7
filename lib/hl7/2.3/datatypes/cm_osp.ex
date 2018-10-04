defmodule HL7.V2_3.DataTypes.Cmosp do
  @moduledoc """
  The "CM_OSP" (CM_OSP) data type
  """
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
      occurrence_span_code: DataTypes.Ce,
      occurrence_span_start_date: nil,
      occurrence_span_stop_date: nil
    ]
end
